class Persona {
 var property fuerza 
 var property resistencia
 var property estaEnCombate = false
 const pociones = [new PocionMuerdago(tamanioMuerdago = 10)] 	
	
	method tomarPocion(pocion){
		pocion.efecto(self)
	}
}

class Galos {
	var property fuerza 
 var property resistencia
 var property estaEnCombate = false

	method recibirDano(danoRecibido) {
		if(estaEnCombate) {
			const res =  resistencia - danoRecibido 
			if (res >= 0) 
				resistencia = res 
			else estaEnCombate = false
		}  
	} 
}

class PocionDDL {
	method efecto(persona){
		persona.fuerza(persona.fuerza() + 10)

		if (persona.estaEnCombate()){
			 persona.resistencia(persona.resistencia() + 2) }
	}
}

class PocionMuerdago {
	const property tamanioMuerdago

	method efecto(persona){
		var resistencia = 0
		persona.fuerza(persona.fuerza()+  tamanioMuerdago)
		if(tamanioMuerdago >= 5) {
			resistencia = -persona.resistencia() / 2
		}
		persona.resistencia(persona.resistencia()+ resistencia)
	}
}

class PocionAceiteDeRoca {
	const property cantidadIngerida

	method efecto(persona) {
		persona.fuerza(persona.fuerza() * cantidadIngerida)
	}
} 

class Tribu {
	const property integrantes = []
	var formacion

	method poder() = formacion.poder(integrantes.filter({integrante => !integrante.estaEnComnbate()}).sum({integrante => integrante.poder()}))

	method recibirDano(danoRecibido){
		const cantidadDeIntegrantes = integrantes.size()
		var danoARepartir 
		var integrantesALosQueDanar = []
		if(cantidadDeIntegrantes < 10) {
			danoARepartir = danoRecibido / cantidadDeIntegrantes
			integrantesALosQueDanar = integrantes.take(cantidadDeIntegrantes)
		}
		else {
			danoARepartir = danoRecibido / 10
			integrantesALosQueDanar = integrantes.take(10)
		}
		integrantesALosQueDanar.forEach({integrante => integrante.recibirDano(formacion.danoARecibir(danoARepartir))})
		if(self.poder <= 0) formacion = formacionTortuga
	}

	method estaEnCombate() = integrantes.all({integrante => !integrante.estaEnCombate()})

	method pelear(enemigo) {
		if(enemigo.estaEnCombate()) {
				if (enemigo.poder() > self.poder()) {
					self.recibirDano(enemigo.poder() - self.poder())
				}
				else {
					enemigo.recibirDano(self.poder() - enemigo.poder())
				}
		}
	}

	method tomarFormacion(tipoFormacion){
		formacion = tipoFormacion
	}
}

object formacionEncuadro {
	var property cantidadQueVanDelante = 10
	method poder(poder) = poder
	method cuantosVanDelante(integrantes) = cantidadQueVanDelante
	method danoARecibir(dano) = dano
}

object formacionTortuga {
	method poder(poder) = poder
	method cuantosVanDelante(integrantes) = 0
	method danoARecibir(dano) = 0
}

object frontemAllargate {
	method poder(poder) = poder * 1.1
	method cuantosVanDelante(integrantes) = integrantes.size() / 2
	method danoARecibir(dano) = dano * 2
}