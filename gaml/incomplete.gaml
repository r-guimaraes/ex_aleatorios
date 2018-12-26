/***
* Name: SAMU
* Author: Grupo UFG (Tópicos 1- Inteligência Artificial)
* Description: Simulação atendimento SAMU para atropelamentos
* Tags: GAMA, SAMU
***/

model SAMU

global {
	
	// Carrega shapefiles que representam os prédios e as ruas conforme o mapa de Goiânia do entorno do SAMU - Parque Areião (Setor Pedro Ludovico)
	file shape_file_building <- file("../includes/predios.shp");
	file shape_file_linha <- file("../includes/linhas.shp");
	file shape_file_multi_linhas <- file("../includes/multi_linhas.shp");
	
	geometry shape <- envelope(shape_file_linha);
	
	// Variáveis iniciais com quantidades de cada specie
	int nb_pessoas <- 60;
	int nb_carros <- 300;
	int nb_ambulancia <- 1;
	int nb_samubase <- 1;
	int nb_hospital <- 1;
	int nb_atropelados <- 0;
	int ContPessoas <- 0;
	int ContAtropelado <- 0;
	float step <- 15 #s;
	graph road_network;
	map<linha,float> road_weights;
	pessoas p;


init {	
	
	// Inicializa prédios conforme shapefile, definindo cores dos prédios conforme o tipo de construção 
	// Tipos podem ser Residencial, Hospital, SAMU ou Industrial
	create predios from: shape_file_building 
	{
		if type="Residential" {			
			color <- #fuchsia ;
		}
			
		if type="Hospital" {
			color <- #black ;
		}
			
		if type = "SAMU" {
			color <- #green;
		}
			
		if type = "Industrial" {
			color <- #dimgray;
		}
	}	
		
	create linha from: shape_file_linha; 
	
	list<predios>  residential_buildings <- predios where (each.type="Residential") ;
	list<predios>  industrial_buildings <- predios where (each.type="Insutrial") ;
	list<predios>  hospital_buildings <- predios where (each.type="Hospital") ;
	list<predios>  Samu_buildings <- predios where (each.type="SAMU") ;
	
	create samubase number: nb_samubase;
	create hospital number: nb_hospital;
	
	create carros number: nb_carros {	
		//pesos da estrada//
		road_weights <- linha as_map (each::each.shape.perimeter);
	    road_network <- as_edge_graph(linha);
	      	
		//local onde as pessoas irão iniciar//
		location <- any_location_in(one_of(linha));
	}
		
	create pessoas number:nb_pessoas returns: ps {
		road_weights <- linha as_map (each::each.shape.perimeter);
	    road_network <- as_edge_graph(predios);
	    
		// Local onde as pessoas irão iniciar//
		location <- any_location_in(one_of(residential_buildings));
		
		p <- ps at 0;
	}

	create ambulancia number:nb_ambulancia {
		road_weights <- linha as_map (each::each.shape.perimeter);
	    road_network <- as_edge_graph(linha);
	    objetivo <- "resgatar";
		//local onde as pessoas irão iniciar//
		Inicio <- one_of(Samu_buildings);
		hospital_leva <- one_of(hospital_buildings);
		location <- any_location_in(Inicio); 
	}
	
  } // init
  
  // Reflexo global para atualizar a cada ciclo o número de pessoas atropeladas
  reflex conta_atropelados {
  	nb_atropelados <- pessoas count (each.atropelado);
  }
  
} // global
	

/* Espécie de carro, com skill apenas de movimentar-se */   
species carros skills: [moving] {
 
 	bool atropelado <-true;
	point target;
	// Probabilidade do motorista fugir sem prestar atendimento à vítima 
	float leaving_probability <- 0.10;

	float speed <- 40 #km/#h; // velocidade padrão de tráfego dos carros
	rgb color <- #darkblue; // cor dos carros
		
	// Se o motorista fugir do local (leaving_probability) e não tiver destino certo, fuja para qualquer lugar demarcado
	reflex leave when: (target = nil) and (flip(leaving_probability)) {
		target <- any_location_in(one_of(linha));
	}

	reflex move when: target != nil {
		do goto target: target on: road_network recompute_path: false move_weights: road_weights;
		
		if (location = target) {
			target <- nil;
		}	
	}
	
  aspect base {
  	draw circle(15) color: color;
  }
	
} // carros

/* Espécie pessoas, com skill de movimentar-se e fipa */
species pessoas skills: [moving, fipa] {

	// Inicialmente, pessoa ainda não foi atropelada
	bool atropelado <- false;
	// Como não foi atropelada, não necessita de resgate
	bool resgate <- false;	
	// Probabilidade de ir embora em caso de acidente
	float leaving_probability <- 0.05;
	predios hospital_leva;
	point ptarget; 
	int distancia_atropela <- 5;
	float speed <- 10 #km/#h; // Velocidade média que uma pessoa costuma andar
	rgb color <- #yellow; // cor padrão das pessoas, conforme Simpsons	
	
	reflex leave when: (ptarget = nil) and (flip(leaving_probability)) {
		ptarget <- any_location_in(one_of(predios));
	}
		
	// Anda pela rodovia demarcado enquanto não tiver sido atropelada
	reflex move when: atropelado = false {
	do goto target: ptarget on: road_network recompute_path: false move_weights: road_weights;
		
		if (location = ptarget) {
			ptarget <- nil;
		}		
	}

	reflex sofre_atropelamento when: !empty(carros at_distance distancia_atropela) {
		
		// Se o carro estiver à distância mínima da pessoa, sofre o atropelamento
		ask carros at_distance distancia_atropela {
			if (self.atropelado) {
				myself.atropelado <- true;
				
				// Informa no console que houve um novo atropelamento
				write "Novo atropelamento!! " + myself.name + " (Ciclo " + cycle + ")";
				
		        myself.ptarget <- location;
			} 
			
			else if (myself.atropelado) {
				self.atropelado <- true;
				ContAtropelado <- pessoas count (atropelado);
			}
		}
	}

	  reflex print_debug_infor when: (atropelado = true)  {
		//write name + ' Fui atropelado ' + string(conversations) + '; messages: ' + string(mailbox);
	}
	
	reflex reply_messages when: (!empty(requests) and (atropelado = true)) {
		message requestFromInitiator <- (requests at 0);
		//write  name + 'Socorro';
		do agree message: requestFromInitiator contents: ['Processando'] ;
		
		write name + ' ';
		write 'inform the initiator';
		
		do inform message: requestFromInitiator contents: ['Enviando ambulancia'] ;
	}
		
	aspect base {
		// Pessoas atropeladas são demarcadas com verde. Não-atropeladas, amarelo
  		draw circle(10) color: atropelado ? #green : #yellow;
  	}
	
} // pessoas

/* Espécie prédio, sem skills especiais */
species predios {	
	string type; 
	rgb color <- #gray;
	
	// Prédios cinzas por padrão, com base nos shapefiles
	aspect default {
		draw shape color: color;
	}
} // prédios

/* Espécie linha, representando as ruas, sem skills especiais */
species linha {

	float speed_coeff <- 1.0 update:  exp(-nb_carros/capacity) min: 0.001;
	float capacity <- 1 + shape.perimeter/50;

	int nb_carros <- 0 update: length(carros at_distance 1);
	int nb_pessoas <- 0 update: length(pessoas at_distance 1);
	int nb_ambulancia <- 0 update: length(ambulancia at_distance 1);
	
	int buffer <- 10;

	aspect default {
		draw (shape + buffer * speed_coeff) color: #deeppink;
	}
} // linha
	
/* Espécie ambulância, com skill de movimentar-se e fipa */
species ambulancia skills: [moving, fipa] {
	predios Inicio <- nil;
	predios hospital_leva <-nil;
	point mtarget;
	string objetivo;
	float leaving_probability <- 0.06; 
	float speed <- 40 #km/#h;
	file _ambulancia <- image_file("../includes/images/ambulancia.png");
	// rgb color <- #red;
	int distancia_resgate <- 5;
	int ContPessoas <- 0;
	bool voltarBase;
	point var;

	// Acionada apenas quando alguma pessoa é atropelada
	// A partir daí, a leva ao hospital
	reflex resgata {
		ask pessoas {			
			if (self.atropelado = true) {
				myself.objetivo <- "LevarAoHospital";
				myself.mtarget <- location; 
		 	}
	   }
	   do goto target: mtarget on: road_network recompute_path: false move_weights: road_weights;
	}

	reflex update {
		var <- mtarget;
		ask pessoas at_distance distancia_resgate {	
			myself.objetivo <- "hospital";
			write "Resgate chegou! (Buscando pessoa no ciclo: " + cycle + ")";						
			do die;		
		}
		
		if (objetivo = "hospital") {
			write "Indo para o hospital";
			
			location <- any_location_in(hospital_leva);
			do goto target: location on: road_network recompute_path: true move_weights: road_weights speed: 17.0;
			write "Deixei pessoa no hospital, voltando para base";
			
			objetivo <- "indo";		
		}
		
		if (objetivo = "indo") {
			self.voltarBase <- true;
			objetivo <- nil;
		}			
 	}
 	
 	reflex voltar when: voltarBase {
 		write "Voltando para base";
		location <- any_location_in(Inicio);			
		do goto target: location on: road_network recompute_path: false move_weights: road_weights speed: 15.0;  	
		voltarBase <- false;
 	}
    
	aspect base {
  		// draw circle(20) color: color;
  		draw _ambulancia size: 50;
  	}  
//  	reflex movement {
//		
//		//The operator goto is a built-in operator derivated from the moving skill, moving the agent from its location to its target, 
//		//   restricted by the on variable, with the speed and returning the path followed
//		my_path <- self goto (on:the_graph, target:target, speed:10, return_path: true);
//		
//		//If the agent arrived to its target location, then it choose randomly an other target on the road
//		if (target = location) {			
//			target <- any_location_in(one_of (road)) ;
//			source <- location;
//		}
//	}
	
} // ambulancia
	
/* Espécie base do SAMU */
species samubase skills: [fipa] {

	reflex print_debug_infor {
		//write name + ' Olá, aqui é o SAMU. Recebemos seu chamado' + string(conversations) + '; messages: ' + string(mailbox);
	}
	
	reflex send_request when: (time = 1) {
		write 'send message';
		do start_conversation to: [p] protocol: 'fipa-request' performative: 'request' contents: ['go sleeping'] ;
	}

	reflex read_agree_message when: !(empty(agrees)) {
		write 'read agree messages';
		loop a over: agrees {
			write 'agree message with content: ' + string(a.contents);
		}
	}
	
	reflex read_inform_message when: !(empty(informs)) {
		write 'read inform messages';
		loop i over: informs {
			write 'inform message with content: ' + string(i.contents);
		}
	}
	  		
} // samubase

species hospital skills: [fipa] {
	
} // hospital

experiment SAMU type: gui {
	output {
			display samu_parque_areiao type: opengl {
				species predios refresh: false;
				species linha;
				species carros aspect: base;
				species pessoas aspect: base;
				species ambulancia aspect: base;
				species samubase;
				species hospital;
			}
		}
}