model my_grid_model

global{
	float max_range <- 5.0;
	int number_of_agents <- 5;
	int number_of_cars <- 2;
	init {
		create pessoa number:number_of_agents;
		create carro number:number_of_cars;
	}
	reflex update {
		ask pessoa {
			do wander amplitude:180.0;	
			ask my_grid at_distance(max_range)
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
		ask my_grid {
			do update_color;
		}	
	}
}

species pessoa skills:[moving] {
	float speed <- 2.0;
	aspect default {
		draw circle(1) color:#blue;
	}
}

species carro {
	aspect padrao {
		draw circle(1) color: #brown;
	}
}

grid my_grid width:30 height:30 {
	int color_value <- 0;
	action update_color {
		if (color_value = 0) {
			color <- #green;
		}
		else if (color_value = 1) {
			color <- #yellow;
		}
		else if (color_value = 2) {
			color <- #red;
		}
		color_value <- 0;
	}
}

experiment SAMU2 type: gui {
    output {
        display ambienteSAMU type: java2D {
            grid my_grid lines:#black;
            species pessoa aspect:default; 
            species carro aspect:padrao;
        }
    }
}