/***
* Name: SAMU
* Author: rodrigo
* Description: 
* Tags: GAMA, SAMU
***/

model SAMU

global {
	int nb_pessoas_init <- 50;
	init {
		create pessoa number: nb_pessoas_init;
	}
}

/* Espécie Pessoa */
species pessoa {
	string nome;
	int idade;
	float tamanho <- 1.2;
	rgb cor <- #brown;
	lugar posicao <- one_of (lugar);
	
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

	lugar escolher_lugar {
		return (posicao.vizinhos) with_max_of (each.food);
	}

}

grid lugar width: 50 height: 50 neighbors: 10 {
	float maxFood <- 1.0 ;
	float foodProd <- (rnd(1000) / 1000) * 0.01 ;
	float food <- (rnd(1000) / 1000) max: maxFood update: food + foodProd ;
	rgb color <- rgb(int(255 * (1 - food)), 255, int(255 * (1 - food))) update: rgb(int(255 * (1 - food)), 255, int(255 *(1 - food))) ;
	list<lugar> vizinhos  <- (self neighbors_at 2); 
}

experiment SAMU type: gui {
	
	output {
		display main_display {
			grid lugar lines: #black ;
			species pessoa aspect: pessoa_base;
		}
	}
}
