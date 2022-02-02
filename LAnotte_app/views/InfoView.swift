//
//  InfoView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 01/02/22.
//

import SwiftUI

struct InfoView: View {
	
	@EnvironmentObject var user: User
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		VStack{
			Text("L'Anotte")
				.font(.title3)
				.padding(.top, 2)
			
			TextView(text: "Questa applicazione è stata creata per poter agevolare il processo di decisione e pagamento dei prodotti che si intende acquistare presso uno dei locali che sono presenti all'interno della piattaforma, mettendo a disposizione il proprio menù. E' importante notare che è permesso l'acquisto dei prodotti contenenti alcol solamente agli utenti maggiorenni. Per poter effettuare un ordine, puoi scegliere se visualizzare il menù compelto di un determinato esercente direttamente nella prima pagina dell'applicazione. In alternativa, se hai giù un'idea di cosa vorresti ordinare, puoi scorrere verso destra, nella sezione Prodotti per effettuare una ricerca testuale del prodotto che preferisci.\nPer ogni prodotto è indicato se l'esercente ha segnalato essere vegano, senza glutine e/o alcolico. \nDopo aver effettuato il login, puoi anche selezionare i tuoi prodotti preferiti, in modo da averli sempre nel tab Per me per poterli ordinare più velocemente. \nPuoi effettuare un'ordinazione da un locale per volta. In un'ordinazione ci possono essere prodotti solamente di un locale. Quando vuoi ordinare, sul tab Ordine ti basterà premere sul pulsante apposito per effettuare il pagamento attraverso ApplePay. Vedrai subito il tuo ordine nella sezione Archivio e riceverai una notifica quando il locale avrà finito di preparare la tua ordinazione per permetterti di andare a ritirarlo. In questo momento ti verrà fornito un codice da dare all'esercente nel momento del ritiro per verificare la tua identità. Ti invieremo un'altra notifica per confermarti l'avvenuto ritiro del tuo ordine.\n\nGluten free icon created by Freepik - Flaticon")
				.padding(.trailing, 10)
				.padding(.leading, 10)
				.padding(.bottom, 5)

			
			if user.isLoggedIn{
				if (colorScheme == .dark){
					Button {
						user.logout()
					} label: {
						Text("Logout")
							.frame(minWidth: 0, maxWidth: .infinity)
							.font(.system(size: 18))
							.frame(height: 40)
							.foregroundColor(.black)
					}
					.padding()
					.background(.white)
					.cornerRadius(8)
					.frame(minWidth: 100, maxWidth: 300)
				}
				else {
					Button {
						user.logout()
					} label: {
						Text("Logout")
							.frame(minWidth: 0, maxWidth: .infinity)
							.font(.system(size: 18))
							.foregroundColor(.white)
					}
					.padding()
					.background(.black)
					.cornerRadius(8)
					.frame(width: 200, height: 100, alignment: .leading)
				}
			}
		}
	}
}


struct SwiftUIView_Previews: PreviewProvider {
	static var previews: some View {
		InfoView().environmentObject(User())
	}
}
