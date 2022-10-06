object reserva {
	const habitats = []
	
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
	const seresVivos = []
	
	method tieneEspecie(especie) = seresVivos.any({ser => ser.especie() == especie})
	method biomasa() = seresVivos.sum({ser => ser.biomasa()})
	method estaEnEquilibrio() = (self.ejemplares("grande") < self.ejemplares("pequenio") / 3) && self.hayAlgunoVivo()
	method hayAlgunoVivo() = seresVivos.any({ser => ser.estaVivo()})
	method ejemplares(tamanio) = seresVivos.count({ser => ser.tamanio() == tamanio})
	method incendio() {
		seresVivos.forEach({ser => ser.sufrirIncendio()})
	}
}

class Granja inherits Habitat{
	
	method sacarUno() {
		seresVivos.remove(seresVivos.anyOne())
	}
	
	method hidratarATodos(){
		seresVivos.forEach({ ser => ser.tomarAgua() })
	}
	
	override method estaEnEquilibrio() = seresVivos.all({ ser => ser.estaHidratado() })

	method hayComida() = seresVivos.any({ ser => ser.estaListo() })
}

class Cueva inherits Habitat{
	var property metrosCuadrados = 1
	
	override method biomasa() = super() + (metrosCuadrados *10)
	
	method nivelDeMarcianilidad(){
		if(!self.hayAlgunoVivo())
			throw new Exception(message = "Ojo al piojo")
			
		return self.biomasa() * 10
	}
}





class SerVivo{ // esto es una clase abstacta, no nos interesa hacer un new SerVivo
	var vivo = true
	var property hidratacion = 10
		
	method estaVivo() = vivo
			
	method tomarAgua() {
		hidratacion = 100.min(hidratacion * 1.1)
	}
	
	method estaHidratado() = hidratacion >= 50
						//pepita.estaListo() -> self es pepita 
						// potus.estaListo() -> self es potus
	method estaListo() = !self.estaVivo() && !self.esPequenio()
	
	method esPequenio() = self.tamanio() == "pequenio" 
	
	method tamanio() // esto es un metodo abstracto, es documentacion
}

class Planta inherits SerVivo{
	var property altura;
	const property especie; 
	
	method biomasa() = 50.min(altura * 2)
	method tamanio() = if (altura >= 10) "grande" else "pequenio"
	method sufrirIncendio() {
		if (self.tamanio() == "pequenio") {vivo = false}
		else altura -= 5
	}
}

class Animal inherits SerVivo{
	const property especie;
	var property peso;

	method biomasa() = peso ** 2 / especie.coeficiente() 
	method tamanio() = 
		if (peso < especie.pesoReferencia()) "pequenio"
		else if (peso > 2 * especie.pesoReferencia()) "grande"
		else "mediano"
			
	method sufrirIncendio() {
		vivo = self.especie().formaLocomocion().seSalva(self.tamanio()) 
		peso -= peso * 0.9
	}	
}



class Especie{
	const property coeficiente = 1;
	const property formaLocomocion = quieto;
	const property pesoReferencia = 1;
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
