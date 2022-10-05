object reserva {
	const habitats = [] //[llanura,bosque,desierto]
	
	method agregarHabitat(habitat) {
		habitats.add(habitat)
	}
	
	method habitats() = habitats
	
	method mayorBiomasa() = habitats.max({habitat => habitat.biomasa()})
	method totalBiomasa() = habitats.sum({habitat => habitat.biomasa()})
	method habitatsNoEnEquilibrio() = habitats.filter({habitat => !habitat.estaEnEquilibrio()})
	method especieEnTodas(especie) = habitats.all({habitat => habitat.tieneEspecie(especie)})
}

class Habitat{
	var property fauna = []
	var property flora = []
	
	method biodiversidad() = fauna + flora
	
	method tieneEspecie(especie) = self.biodiversidad().any({ser => ser.especie() == especie})
	method biomasa() = self.biodiversidad().sum({ser => ser.biomasa()})
	method estaEnEquilibrio() = (self.ejemplares("grande") < self.ejemplares("pequenio") / 3) && self.hayAlgunoVivo()
	method hayAlgunoVivo() = self.biodiversidad().any({ser => ser.estaVivo()})
	method ejemplares(tamanio) = self.biodiversidad().count({ser => ser.tamanio() == tamanio})
	method incendio() {
		
		self.biodiversidad().forEach({ser => ser.sufrirIncendio()})
		//fauna.forEach({animal => animal.sufrirIncendio()})
		//flora.forEach({planta => planta.sufrirIncendio()})
	}
}

class Especie{
	const property coeficiente = 1;
	const property formaLocomocion = quieto;
	const property pesoReferencia = 1;
}

class Planta{
	var property altura;
	const property especie;
	var vivo = true
	
	method estaVivo() = vivo
	method biomasa() = 50.min(altura * 2)
	method tamanio() = if (altura >= 10) "grande" else "pequenio"
	method sufrirIncendio() {
		if (self.tamanio() == "pequenio") {vivo = false}
		else altura -= 5
	}
}

class Animal{
	const property especie;
	var property peso;
	var vivo = true
	
	method estaVivo() = vivo
	method biomasa() = peso ** 2 / especie.coeficiente() 
	method tamanio(){ 
						if (peso < especie.pesoReferencia()){
							return "pequenio"
						}
						else if (peso > 2 * especie.pesoReferencia()){
							return "grande"
						}
						else{
							return "mediano"
						}
					}
	method sufrirIncendio() {
		//if (!((self.especie().formaLocomocion() == "volar" && self.tamanio() == "grande") || 
			 //  self.especie().formaLocomocion() == "nadar" ||
			  //(self.especie().formaLocomocion() == "correr" && self.tamanio() == "mediano"))) {vivo = false}
		
		vivo = (self.especie().formaLocomocion().seSalva(self.tamanio()))
		//if(!(self.especie().formaLocomocion().seSalva(self.tamanio()))) {vivo = false}
		//hacer que los metodos de locomoción sea un objeto y que entienda un mensaje 
		// 
		self.perderPeso(0.1)
	}
	
	method perderPeso(porcentaje) {peso -= peso*porcentaje}	
}

object volar{
	method seSalva(tamanio) = tamanio == "grande"
}

object nadar{
	method seSalva(tamanio) = true 
}

object correr{
	method seSalva(tamanio) = tamanio == "mediano"
}

object quieto{
	method seSalva(tamanio) = false
}
