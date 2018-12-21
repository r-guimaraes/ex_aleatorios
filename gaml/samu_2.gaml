model my_grid_model

global{
	float max_range <- 5.0;
	float min_range <- 2.0;
	int number_of_agents <- 5;
	int number_of_cars <- 2;
	init {
		create pessoa number:number_of_agents;
		create carro number:number_of_cars;
	}
	reflex update {
		ask pessoa {
			do wander amplitude:180.0;	
			ask centro_goiania at_distance(max_range)
			{
				if(self overlaps myself)
				{
					self.color_value <- 2;
				}
				else if (self.color_value != 2)
				{
					self.color_value <- 1;
				}
			}
		}
		
		ask carro {
			do wander amplitude:180.0;	
			ask centro_goiania at_distance(min_range) {
				if (self overlaps myself) {
					self.color_value <- 3;
				}
			}
		}
		
		ask centro_goiania {
			do update_color;
		}		
	} // reflex update
	
	reflex atropela {
		ask pessoa {
			ask carro at_distance(min_range) {
				if (self overlaps myself) {
					write string("BATEU!!");
					myself._color <- 1;
				}
			}
		}
		
		ask pessoa {
			do atualiza_ai;
		}
	} // reflex atropela
}

species pessoa skills:[moving] {
	float speed <- 2.0;
	file _pessoa <- image_file("../includes/images/usuario.jpg");
	float tamanho <- 1.1;
	int _color <- 0;
	
	action atualiza_ai {
		if (_color = 0) {
			color <- #blue;
		} else if (_color = 1) {
			color <- #red;
		}
		_color <- 0;
	}
	
	aspect default {
		//draw _pessoa size: 2 * tamanho;
		draw circle(1) color: #blue;
	}
}

species carro skills:[moving] {
	aspect padrao {
		draw sphere(1) color: #green;
	}
}

grid centro_goiania width:30 height:30 {
	int color_value <- 0;
	action update_color {
		if (color_value = 0) {
			color <- #grey;
		}
		else if (color_value = 1) {
			color <- #yellow;
		}
		else if (color_value = 2) {
			color <- #orange;
		}
		else if(color_value = 3) {
			color <- #black;
		}
		color_value <- 0;
	}
}

experiment SAMU2 type: gui {
    output {
        display ambienteSAMU type: java2D {
            grid centro_goiania lines:#black;
            species pessoa aspect:default; 
            species carro aspect:padrao;
        }
    }
}