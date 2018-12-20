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
	}
}

/* Espécie Pessoa */
species pessoa {
	string nome;
	int idade;
	float tamanho <- 1.1;
	rgb cor <- #brown;
	lugar posicao <- one_of (lugar);
	file _pessoa <- image_file("../includes/images/usuario.jpg");
	
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
	
	reflex drive {
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
		draw _ambulancia size: 1.5 * tamanho;
	}
}

/* Espécie Carro */
species carro parent: automovel {	
	rgb cor <- pega_cor();	
	rgb pega_cor {
		return #blue;
	}
}

grid lugar width: 50 height: 50 neighbors: 10 {
	float maxFood <- 1.0 ;
	float foodProd <- (rnd(1000) / 1000) * 0.01 ;
	float food <- (rnd(1000) / 1000) max: maxFood update: food + foodProd ;
	rgb color <- rgb(int(225 * (1 - food)), 255, int(255 * (1 - food))) update: rgb(int(255 * (1 - food)), 255, int(255 *(1 - food))) ;
	list<lugar> vizinhos  <- (self neighbors_at movimentacao); 
}

experiment SAMU type: gui {
	
	output {
		display main_display {
			grid lugar lines: #black;
			species pessoa aspect: icone;
			species carro aspect: auto_base;
			species ambulancia aspect: icone;
		}
	}
}
