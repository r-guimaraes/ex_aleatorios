/***
* Name: SAMU
* Author: Grupo UFG (Tópicos 1- Inteligência Artificial)
* Description: Simulação atendimento SAMU para atropelamentos
* Tags: GAMA, SAMU
***/

model SAMU

global {
	
	// Qtds iniciais das species
	int qtd_pessoas <- 50;
	int qtd_ambulancias <- 5;
	int qtd_carros <- 20;
	
	// Range de movimentação das species
	float movimentacao <- 3.5;
	
	init {
		create pessoa number: qtd_pessoas;
		create ambulancia number: qtd_ambulancias;
		create carro number: qtd_carros;		
		create departamento number: 1;
	}
}

/* Espécie Pessoa */
species pessoa {
	bool atropelada <- false;
	float tamanho <- 1.1;
	rgb cor <- #brown;
	lugar posicao <- one_of (lugar);
	file _pessoa <- image_file("../includes/images/usuario.png");
	file _atropelado <- image_file("../includes/images/usuario-atropelado.png");
	
	init {
		location <- posicao.location;
	}
	
	reflex andar {
		posicao <- escolher_lugar();
		location <- posicao.location; 
	} 
	
	aspect pessoa_base {
		draw sphere(tamanho) color: cor;
	}
	
	aspect icone {
		draw _pessoa size: 2 * tamanho;
		
		list<carro> armas;
		ask armas at_distance(1.0) {
			write string("nossa deu ruim!!");
			draw myself._atropelado size: 3 * tamanho;
		}
	}
	
	reflex marcar when: atropelada {
		_pessoa <- _atropelado;
	}

	lugar escolher_lugar {
		return (posicao.vizinhos) with_max_of (each.food);
	}
}

/* Veículo Genérico */
species automovel {
	float tamanho <- 1.5;
	rgb cor;
	lugar posicao <- one_of(lugar);
	
	aspect auto_base {
		draw sphere(tamanho) color: cor;
	}
	
	lugar escolher_lugar {
		return (posicao.vizinhos) with_max_of (each.food);
	}
	
	reflex dirigir {
		posicao <- escolher_lugar();
		location <- posicao.location;
	}
	
	init {
		location <- posicao.location;
	}
}

/* Espécie Ambulância */
species ambulancia parent: automovel {
	file _ambulancia <- image_file("../includes/images/ambulancia.png");
	rgb cor <- pega_cor();	
	rgb pega_cor {
		return #red;
	}
	
	aspect icone {
		draw _ambulancia size: 1.7 * tamanho;
	}
}

species departamento{
	float size <- 5.0 ;
	rgb color <- #purple;
	lugar meuEspaco <- one_of (lugar);//coloca o departamento dentro do metro;
	// list<item> itensDep;

	aspect base{
		draw cube(size) color: color;
	}
	
} 

/* Espécie Carro */
species carro parent: automovel {	
	rgb cor <- pega_cor();	
	rgb pega_cor {
		return #blue;
	}
	
	list<pessoa> pedestres update: pessoa inside (posicao);
	
	reflex atropela when: !empty(pedestres) {
		ask one_of (pedestres) {
			//pessoa.atropelada <- true;
			write string("Atropelei uma pessoa! Na posição: " + posicao);
			draw sphere(1.6) color: #red;
		}
		
		//pessoa p <- pedestres at posicao;
		// p.atropelada <- true;
//		energy <- energy + energy_transfert ;
	}
}

grid lugar width: 50 height: 50 neighbors: 10 {
	int base_color_code <- 192; // 255 (verde)
	
	float maxFood <- 1.0 ;
	float foodProd <- (rnd(1000) / 1000) * 0.01 ;
	float food <- (rnd(1000) / 1000) max: maxFood update: food + foodProd ;
	rgb color <- rgb(int(base_color_code * (1 - food)), base_color_code, int(base_color_code * (1 - food))) update: rgb(int(base_color_code * (1 - food)), base_color_code, int(base_color_code *(1 - food))) ;
	list<lugar> vizinhos  <- (self neighbors_at movimentacao); 
}

experiment SAMU type: gui {
	
	output {
		display main_display {
			grid lugar lines: #black;
			species pessoa aspect: icone;
			species carro aspect: auto_base;
			species ambulancia aspect: icone;
			species departamento aspect: base;
		}
	}
}
