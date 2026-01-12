class AppConfig {
  static String host = "authsmtp.3em.it";
  static int port = 25;

  static int oggettoIndex = 1;
  static int nameIndex = 2;
  static int datiCount = 3;

  static bool sendFile = true;
  static bool searchOggetto = true;

  static String splitSymbol = "-";
  static String fileExtension = "pdf";

  static String msg = """Ciao,
Invio in allegato buste paga  come in oggetto.


Ti prego di provvedere alla compilazione del solito Form per le attestazioni di spese non documentate per l'importo che trovi sotto la voce "Rimborso spese piè di lista" in busta paga.

Attendo entrambi i documenti firmati con ogni cortese URGENZA. Qualora non avessi gia' provveduto all'invio degli stessi documenti per I MESI PRECEDENTI, ti ricordo ti inviare tutto CON URGENZA.


Grazie per la collaborazione e saluti



Francesca Scarmozzino

<sub style='color:grey;'>Finance & Administration

<img src='https://www.3em.it/assets/img/blu.svg' width='80' height='80'>

Via Antiniana, 2/G
80078 Pozzuoli (NA)
ITALY


Phone:          +39 081 5234193
Fax:               +39 081 8531552
Mail:             info@3em.it
Site:              www.3em.it


GDPR 2016/679

Il presente messaggio e gli eventuali suoi allegati sono di natura aziendale, prevalentemente confidenziale e sono visionabili solo dal destinatario di posta elettronica. La risposta o l'eventuale invio spontaneo da parte vostra di e-mail al nostro indirizzo potrebbero non assicurare la confidenzialità; potendo essere viste da altri soggetti appartenenti all'Azienda oltre che al firmatario della presente, per finalità di sicurezza informatica, amministrative e allo scopo del continuo svolgimento dell'attività aziendale. Qualora questo messaggio vi fosse pervenuto per errore, vi preghiamo di cancellarlo dal vostro sistema e vi chiediamo di volercene dare cortesemente comunicazione al mittente.


La Vs. mail è in ns. possesso in quanto da Voi fornitaci tramite comunicazione scritta, telefonica, telematica o direttamente oralmente. Essa è utilizzata esclusivamente per fornirVi informazioni sulla ns. attività e sui servizi da noi offerti. Non sarà ceduta a terzi in nessun caso salvo approvazione da parte Vostra. Il Titolare del trattamento è <b>TRE EMME ENGINEERING S.R.L.</b> I ns. sistemi informativi e le ns. procedure interne sono conformi alle norme e garantiamo la presenza di adeguate misure tecniche ed organizzative costantemente aggiornate.


E' possibile in qualsiasi momento richiedere la cancellazione della Vs. mail tramite il semplice invio di una mail a.info@3em.it</sub>""";

  static String firma = """

Francesca scarmozzino

<sub style='color:grey;'>Finance & Administration

<img src='http://parking3em.altervista.org/firma_logo.png' width='80' height='80'>

Via Antiniana, 2/G
80078 Pozzuoli (NA)
ITALY


Phone:          +39 081 5234193
Fax:               +39 081 8531552
Mail:             info@3em.it
Site:              www.3em.it


GDPR 2016/679

Il presente messaggio e gli eventuali suoi allegati sono di natura aziendale, prevalentemente confidenziale e sono visionabili solo dal destinatario di posta elettronica. La risposta o l'eventuale invio spontaneo da parte vostra di e-mail al nostro indirizzo potrebbero non assicurare la confidenzialità; potendo essere viste da altri soggetti appartenenti all'Azienda oltre che al firmatario della presente, per finalità di sicurezza informatica, amministrative e allo scopo del continuo svolgimento dell'attività aziendale. Qualora questo messaggio vi fosse pervenuto per errore, vi preghiamo di cancellarlo dal vostro sistema e vi chiediamo di volercene dare cortesemente comunicazione al mittente.


La Vs. mail è in ns. possesso in quanto da Voi fornitaci tramite comunicazione scritta, telefonica, telematica o direttamente oralmente. Essa è utilizzata esclusivamente per fornirVi informazioni sulla ns. attività e sui servizi da noi offerti. Non sarà ceduta a terzi in nessun caso salvo approvazione da parte Vostra. Il Titolare del trattamento è <b>TRE EMME ENGINEERING S.R.L.</b> I ns. sistemi informativi e le ns. procedure interne sono conformi alle norme e garantiamo la presenza di adeguate misure tecniche ed organizzative costantemente aggiornate.


E' possibile in qualsiasi momento richiedere la cancellazione della Vs. mail tramite il semplice invio di una mail a.info@3em.it</sub>""";
}
