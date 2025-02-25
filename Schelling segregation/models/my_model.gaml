/**
* Name: mymodel
* Based on the internal empty template. 
* Author: SON GIANG
* Tags: 
*/


model mymodel

/* Insert your model definition here */

//--> global để định người biến global, khời tạo quần thể, hoặc di chuyển quần thể, biến đổi ...
global {
	// tạo ra một quần thể people với các attribute chung như được định nghĩa ở dưới đây.
	float rate_similar_wanted <- 0.4;
	float neighbours_distance <- 5.0;
	int nb_happy_people <- 0 update: people count each.is_happy; // đếm và cập nhật lại số người happy sau mỗi bước của simulation
	init {
		create people number: 5000;
	}
	reflex end_simulation when: nb_happy_people = length(people){
		do pause; // dùng chương trình
	}
}

// species để định nghĩa ra kiểu phần tử, có thể có nhiều species
species people{
	rgb color <- (flip(0.5) ? #red : #yellow);
	list<people> neighbours update: people at_distance neighbours_distance; // ở mỗi bước của simulation nó sẽ update lại
	// cái list neighbours này dựa theo phương thức at_distance kia
	bool is_happy <- false;
	aspect asp_circle{
		draw circle(1.0) color: color border: #black;
	}
	
//	reflex move {
//		location <- any_location_in(world.shape);
//	}

	// sửa lại reflex move --> chỉ move khi cảm thấy unhappy
	reflex move when: not is_happy{
		location <- any_location_in(world.shape);
	}
	
	reflex computing_similarity{ // thực hiện hành động ở mỗi step của simulation
		float rate_similar <- 0.0;
		if (empty(neighbours)){ // --> ở trong gama thường là tên hàm(tên cái sẽ thực hiện trên đó)
			rate_similar <- 1.0;
		}
		else {
			int nb_neighbours <- length(neighbours);
			int nb_neighbours_sim <- count(neighbours, each.color = color);
			rate_similar <- nb_neighbours_sim / nb_neighbours;
		}
		is_happy <- rate_similar >= rate_similar_wanted;
	}
}

/* experiemnt this is for input and output ?*/ // --> trong 1 chương trình có thể có nhiều loại experiment khác nhau
experiment Schelling1 type: gui{
	output{
		display people_display {
			species people aspect: asp_circle;
		}
	}
}