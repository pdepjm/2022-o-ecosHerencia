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
	
	method sacarSerVivo(){
		const serVivo = seresVivos.head()
		seresVivos.drop(1)
		return serVivo
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
	method tamanio() = 
		if (peso < especie.pesoReferencia()) "pequenio"
		else if (peso > 2 * especie.pesoReferencia()) "grande"
		else "mediano"
			
	method sufrirIncendio() {
		vivo = self.especie().formaLocomocion().seSalva(self.tamanio()) 
		peso -= peso * 0.9
	}	
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
