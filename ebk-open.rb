def progexist?(progname);`whereis #{progname}`!="#{progname}:\n" ? (return true) : (return false);end
def spaceOpen?
	require "net/http"
	require "json"
	return JSON.parse(Net::HTTP.get(URI("http://eigenbaukombinat.de/status/status.json")))["state"]["open"]
end

# Auf Kompatibilität überprüfen

if !progexist?("notify-send")
	puts "Es tut mir ausserordentlich leid, aber dieses Skript ist nicht mit deinem Betriebssystem verfuegbar."
	puts "Besuche doch einfach das zugehoerige Github-Repository und lade dir den Installer herunter,"
	puts "wenn du dir nicht sicher bist, welche Version du benoetigst."
	puts "(der Installer existiert noch nicht, wird aber noch mitsamt anderen Versionen bald dazukommen)"
	abort
end

# Das Programm existiert, es kann losgehen

$OPEN = spaceOpen?

def sendmsg(urgency,head,text);`notify-send -u #{urgency} "#{head}" "#{text}"`;nil;end
sendmsg("low","Du hast das Skript erfolgreich gestartet,", "wenn du das hier siehst.")
sendmsg("low","Das Space ist momentan uebrigens...",(spaceOpen? ? ("...offen!") : ("...geschlossen!")))

loop do
	if spaceOpen? != $OPEN
		sendmsg("normal","Das Space ist jetzt...",(spaceOpen? ? ("...offen!") : ("...geschlossen!")))
		$OPEN = spaceOpen?
	end
	sleep 1
end
