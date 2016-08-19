# Algumas regras do iptables retiradas do Livro: Servidores Linux, guia prático - Carlos E. Morimoto por João Lucas. 
# Data: 2016-08-18

# 
## Parâmetros do Iptables:
 -A INPUT: Especifica que a regra se aplica a pacotes de entrada, ou seja, pacotes recebidos pelo servidor, em qualquer interface.
 -A OUTPUT: A regra se aplica a pacotes de saída, transmitidos pelo proprio servidor.
 -A FORWARD: Este parâmetro é usado ao compartilhar a conexão co a Internet, permitindo que os micros da rede local acessem atráves do servidor. Os pacotes de outros micros, encaminhados pelo servidor, são tratados como FORWARD, diferentemente dos pacotes transmitidos pelo próprio servidor, que são tratados como "OUTPUT. Você pode definir regras diferentes para cada situação"
 -p tcp: Especifica que a regra se aplica a pacotes TCP, o que é o mais comum.
 -p udp: Alguns serviços usam também portas UDP. Um bom exemplo são os servidores DNS, qie escutam tanto na porta 53 TCP, quanto na 53 UDP.
 -p icmp: Usado para controle, pings e envio de mensagens
 -p ALL: Aplica a regra aos três protocolos: TCP, UDP e ICMP

# Como as portas UDP também são usadas por alguns serviços, é muito comum bloquear as prtas de 0 a 1023 UDP, autorizando apenas as portas que realmente deve ficar abertas, como em:
iptables -A INPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --dport 0:1023 -j DROP

-i eth0: Permite especificar a interface onde os pocotes devem ser recebidos ou enviaos. Por exemplo:
iptables -A INPUT -p tcp -j REJECT
# Simplesmente desconectaria seu micro da rede, pois bloquearia  comunicações em qualquer interface. Poém, se você especificasse a interface, ele bloquearia apenas pacotes recebidos atráves dela, como em:
iptables -A INPUT -pi eth2 -p tcp -j REJECT

# O mesmo se aplica quando você quer permitir conexões em determinaas portas, mas apenas a partir da placa de rede local. Para permitir conexões via SSH apenas a parit da placa eth0, você poderia usar:
iptables -A INPUT -i eth0 -p tcp --dport 22 -j ACCEPT

-o eth0: É similar ao parâmeto "-i", mas especifica uma interface de saída. Este parâmetro é menos usado, pois normalmente nos preucuṕamos em impedir que o firewall aceite conexões em determinadas portas, em vez de tentar interceptar as respostas.

--dport ou --destination-port: Especifica uma porta. 

-s(source): Especifica um endereço IP ou dominio de origem de forma a aceitar ou recusar as conexões. Embora seja muito fácil forjar endereços IP dentro da rede local, as coisas são muito mais complicadas na internet. Permitir o acesso a determinadas portas(como a SSH) apenas para determinadas endereços, ou faixas de endereços, é uma medida de segurança interessante em muitas situações.

# Este é um exemplo de regra, que abre a porta 631 apenas para hosts dentro da faixa a máscara especificada:
iptables -A INPUT -p tcp -s 72.232.35.0/255.255.255.248 --dport 631 -j ACCEPT

-d(destiny): Destinado ao endereço IP ou domínio citado. É muito usado ao bloquear o acesso a determinados sites a partir dos micros da rede local como, por exemplo:
iptables -A FORWARD -d torrentreactor.net -j REJECT

-m mac --mac-source 00:11:F4:34:89:3A: Esta é a regra que permite especificar endereços MAC dentro de regras do Iptables que vimos há pouco.
# Esta é uma forma de dificultar o uso de endereços IP falseados para ganhar acesso ao servidor, pois permite relacionar o IP ao endereço MAC da placa instalada. Lembre-se, porém, que ela só pode ser usada em rede local e que os endereços MAC são quese tão fáceis de falsear quanto os endereços IP.
# Um exemplo seria:
iptables -A INPUT --dport 22 -m mac --mac-source 00:11:F4:34:89:3A

--syn: Cria uma regra válida apenas para novas conexões, não impedindo que o outro micro responda a conexões iniciadas pelo servidor, como em:
iptables -A INPUT -p tcp --syn -j DROP

-j: É usado no final de cada regra, especificando uma ação, que pode ser:
-j ACCEPT: Aceita o pacote. Ele é encaminhado ao destino sem passar pelas demais regras.
-j REJECT: Rejeita educadamente o pacote, enviando um pacote de resposta ao emissor.
-j DROP: O DROP é mais enfático. O pacote é simplesmente descartado, sem aviso. O emessor fica um longo tempo esperando, até que eventualmente recebe um erro de time-out
-j LOG: Permite logar conexões. É importa usar esta regra principalmente em portas muito visdas, como a do SSH, pois assim você tem uma lista de todos os endereços que acessaram seu servidor na porta especificada. Para ativar o log, você deve duplicar a regra que abre a porta, usando a opção "-j LOG" na primeira e "-j ACCEPT" na segunda, como em:
iptables -A INPUT -p tcp --dport 22 -j LOG # note que a regra LOG deve vir primeiro que a ACCEPT, caso contrário, os pacotes serão aceitos primeiros e não terá como registrar o evento no lOG depois.
iptables -A INPUT -p tcp 22 --dport 22 -j ACCEPT

# As mensagens são gravadas em "/var/log/messages" de forma bastante detalhada, incluindo a data e hora da conexão, o IP e MAC do micro que fez a conexão(SRC), além da porta(DPT). Você pode ver o mesmo log, porém com as entradas escritas de forma resumida, usando o comando "dmesg"



#
## Trabalhando com portas de entrada (sentido internet > rede local)
# Algumas regras do iptables 

#  loopback é usada por diversos programas como programas graficos
iptables -A INPUT -i lo -j ACCEPT

# Bloquear conexões vindo da internet
iptables -A INPUT -p tcp --syn -j DROP

# Abre para uma faixa de endereços:
iptables -A INPUT -s 192.168.1.0/255.255.255.0 -j ACCEPT	

# Aceita tudo na interface de rede local:
iptables -A INPUT -i eth0 -j ACCEPT

# Verifica tanto a interface quanto a faixa de endereços de origem:
iptables -A INPUT -s 192.168.1.0/255.255.255.0 -i eth0 ACCEPT

# Abre uma porta (inclusive para internet):
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Abre um conjunto de portas:
iptables -A INPUT -m multiport -p tcp --dport 22,80,443 -j ACCEPT

# Abre a porta para um IP especifico:
iptables -A INPUT -p tcp -s 200.231.14.17 --dport 22 -j ACCEPT

# Abre um intervalo de portas:
iptables -A INPUT -p tcp --dport 6881:6889 -j ACCEPT

# Verifica tanto o endereço IP quanto o MAC antes de aurotizar a conexão:
iptables -A INPUT -s 192.168.1.100 -m mac --mac-source 00:11:22:33:44:55 -j ACCEPT

#
## Forwarding de portas
# Redireciona uma faixa de portas para um micro da rede local:
echo 1 > /proc/sys/net/ipv4/ip_forward
# Faz com que o servidor encaminhe todas as conexões que receber na interface e porta especificada para o micro da rede local:
iptables -t nat -A PREROUTING -p tcp -i eth1 --dport 6881:6889 -j DNAT --to 192.168.1.10
# Faz com que os pacotes de respostas encidos por ele possam ser encaminhados de volta:
iptables -t nat -A POSTROUTING -d 192.168.1.10 -j SNAT --to 192.168.1.1

# Redireciona uma única porta para um micro da rede local:
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A PREROUTING -p tcp -i eth1 --dport 22 -j DNAT --to 192.168.1.10
iptables -t nat -A POSTROUTING -d 192.168.1.10 -j SNAT --to 192.168.1.1

# Redirecionando um conjunto de portas:
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A PREROUTING -p tcp -i eth1 -m multiport --dport 21,22,80 -j DNAT --to-dest 192.168.1.10
iptables -t nat -A POSTROUTING -d 192.168.1.10 -j SNAT --to 192.168.1.1

# Redirecionar uma porta UDP
echo 1 > /proc/sys/net/ipv4/ip_forward 
iptables -t nat -A PREROUTING -p udp -i eth1 --dport 53 -j DNAT --to 192.168.1.10
iptables -t nat -A POSTROUTING -d 192.168.1.10 -j SNAT --to 192.168.1.1


#
## Bloqueando portas de saída (sentido rede local > internet)
# Bloqueando a porta para FORWARD, você impede o acesso  partir dos micros da rede local, que acessam através da conexão compartilhada pelo servidor.
# Bloqueando para OUTPUT, a porta é bloqueada no próprio micro onde o firewall está ativo.
# Você pode bloquear as duas situações, duplicando a regra:
iptables -A OUTPUT -p tcp --dport 1863 -j REJECT
iptables -A FORWARD -p tcp --dport 1863 -j REJECT

# Bloquear intervalos de portas:
iptables -A FORWARD -p tcp --dport 1025:65536 -j REJECT
# Como estamos criando regras para micros da rede local e não para possíveis invasores da internet, é aconselhável usar a regra REJECT ao invés de DROP. Caso contrário, os programas nos clientes sempre ficarão muito tempo parados ao tentar acessar portas bloqueadas.

# Bloquear um a um todos os programas indesejados acaba sendo tedioso, ao invés disso você pode experimentar uma solução mais redical: inverter a lófica da regra, bloqueando todas as portas de saída e abrindo apenas algumas portas permitidas.
# O Mínimo que você precisa abrir neste caso são as portas 80(HTTP) e 53(DNS). A partir daí, você pode abrir mais portas, como a 25(SMTP), 110(POP3), 443(HTTPS) e assim por diante.
# Exemplo:
iptables -A FORWARD -p udp -i eth0 --dport 53 -j ACCEPT
iptables -A FORWARD -p tcp -i eth0 --dport 80 -j ACCEPT
iptables -A FORWARD -p tcp -i eth0 --dport 443 -j ACCEPT
iptables -A FORWARD -p tcp -i eth0 -j LOG
iptables -A FORWARD -p tcp -i eth0 -j REJECT
# A regra "iptables -A FORWARD -j LOG" é uma boa opção  durante a fase de teste, pois ela faz com que o iptables logue todos os pacotes que forem encaminhados, tanto no envio, quanto na resposta, permitindo que você verifique o que esta ocorrendo quando algo nao estiver funcionando. Você pode acompanhar o log usando o comando dmesg

# Bloqueia o acesso á web a partir de um determinado IP
iptables -A FORWARD -p tcp -s 192.168.1.67 -j REJECT
# Esta regra deve ir logo no inicio do scritp, antes das regras que abrem as portas de saída, caso contrário não surtirá efeito.
# Lembre-se de que o iptables processa as regras sequencialmente: se uma compartilhha a conexão com todos micros da rede, não adianta tentar bloquear para determinados endereços depois. As regras com as excessões devem sempre vir antes da regra mais geral


#
## Bloqueando domínios
# É possivel bloquear ou permitir com vbase no dominio, tanto para entrada quanto saída. Isso permite bloquear sites e programas diretamente a partir do firewall, sem precisar instalar um servidor squid e configura-lo como proxy transparente.
# Neste caso, usamos o parâmetro "-d"(destiny) do iptables, seguido do dominio desejado.
# Para bloquear o facebook
iptables -A OUTPUT -d www.facebook.com -j REJECT
iptables -A FORWARD -d www.facebook.com -j REJECT
#  A primeira linha bloqueia pacotes de saída destinados ao dominio, ou seja, impede que ele seja acessado a partir da propria maquina local. A segunda linha bloqueia o forward de pacotes destinados a ele(dominio), ou seja, impede que outras maquinas de rede local, que acessem atraves de uma conexão compartilhada, acessem o dominio.

 # Se voce for paranoico, você pode usar tambem a regra:
 iptables -A INPUT -s www.facebook.com -j DROP
 # Esta regra impede também que qualquer pacote proviniente de facebook.com chague até sua maquina.

# Assim como no caso do aquid, ao dicidir bloquear o acesso a sites ou endereços diversos utilizando o iptables, voce vai logo acabar com uma lista relativamente grande de endereços a bloquear. Diferente do aquid, o iptables nao oferece uma opção para carregar a lista dos endereços que devem ser bloqueados a partir de um arquivo texto, mas isso pode ser resolvido com um script simples, que leia o conteúdo do arquivo e gere a regras correspondentes.
# Comece criando um arquivo testo contendo os dominios ou endereços IP que deseja bloquear, um por linha:
# >  www.facebook.com
# >  www.xvideos.com
# >  www.orkut.com
# Em seguida, adicione esta função no inicio do seu script de firewall, especificando o arquivo de texto com os endereços:
for end in 'cat /etc/sites_bloqueados'
do
        iptables -A OUTPUT -d $end -j REJECT
        iptables -A FORWARD -d $end -j REJECT
done

#
## Regras adicionais de segurança
# Em um servidor dedicado, não faz muito sentido bloquear a respostas a pings, já que de qualquer forma, ele precisará ficar com um conjunto de portas abertas. Ao invés de bloquear os pings, que afinal podem ser úteis em algumas situações, você pode limitar as respostas a apenas uma por segundo, evitano que alguém de má fé possa enviar um grande volume de pings (como o comando ping -f), como parte de um ataque DoS.
# Nesse caso seria
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT

# Se seu servidor não irá atuar com um roteador, é prudente desativar o suporte a ICMP redirects. Este é um recurso utiizado por roteadores para alertar outros de que existe um melhor caminho para um determinado endereço ou rede, mas não tem uso legitimo em um servidor que não roteia pacotes:
echo 0 > /proc/sys/net/ipv4/conf/all/accept_redirects

# Outra configuração desejada é desativar o suporte a ping broadcasts, um recurso que tem poucos usos legitimos e pode ser usado para fazer com que servidores participem involuntariamente de ataques DoS, enviando grandes quantidades de pings a outros servidores dentreo da mesma faixa de endereços. Ele já vem desativado em quase todas as distruibuições atuais, mas não custa verificar:
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts

# Mais uma opção importante manter desativada é o suporte ao souce routing. Este é um recurso usado para testes de roteadores, que permite ao emissor especificar qual o caminho que o pacote tomará até o destino e também o caminho de volta. Ele é perigoso, pois permite falsear pacotes, fazendo com que eles pareçam vir de outro endereço e, ao mesmo tempo, fazeer com que as respostas realmente sejam recebidas, permitindo abrir a conexão e tranferir dados. Em outras palavra, se voce inclui regras que permitem o acesso de determiandos endereços e esqueceu o suporte source routing ativo, um atacante que soubesse quais são os endereços autorizados poderia abrir conexões com o seu servidor se fazendo passar por um deles, um risco que você cm certeza gostaria de evitar. COmo o recurso não possui outros usos legitimos, é fortemente recomendável que você o mantenha desativado:
echo 0 > /proc/sys/net/ipv4/conf/all/accept_source_route

# Diferente do servidor de rede local que compartilha a conexão, o servidor não deverá compartilhar a conexão, nem encaminhar pacotes de outros hosts. Vocẽ pode deixar explicito desativando o suporte a ip_forward:
echo 0 > /proc/sys/net/ipv4/ip_forward

# Concluindo, temos o suporte a SYN cookies, Um dos tipos mais comuns de ataques DoS e também um dos mais efetivos é o SYN Flood. Este tipo de ataque consiste em enviar um grande volume de pacotes SYN até o alvo, sem nunca efetivamente abrir a conexão. Como os pacotes SYN possuem alguns poucos bytes, o ataque pode ser feito mesmo a partir de uma conexão domestica.
# Como existe um limite de conexões TCP que o servudor pode manter ativas simultaneamente, um grande volume de pacotes SYN podem estourar o limite de conexões, fazendo com que o servidor deixe de responder a novas conexões, mesmo que exista banda disponivel.
# No linux, isso pode ser evitado de forma bastante simples, ativando o iso de SYN Cookies, um recurso oferecido diretamente pelo Kernel, o que é feito com o comando abaixo, que pode incluido no seu script de firewall:
echo 1 > /proc/sys/net/ipv4/ip_syncookies
# Ao atuvas o recurso, o sistema passa a responder ao pacote SYN inicial com um cookie, que identifica o cliente. Com isso o sistema aloca um espaço para a conexão apenas após receber o pacote ACK de resposta, tornando o ataque inefetivo. O atacante ainda pode consumir um pouco de banda, obrigando o servidor a enviar um grande volume de SYN Cookie de resposta, mas o efeito sobre o servidor é minimo

# Concluindo, adicione também as regras que ativam o uso de rp_filter, de forma que o firewall sempre responda aos pacotes na mesma interface da qual eles foram originados, o que previne ataques diversos que tentem tirar proveito da regra que permite conexões na interface de loopback. Outra opção interessante é o blouqeio de pacotes inválifos, o que também melhora a segurança contra ataques diversos, incluindo pacotes enviados sem serem precedidos pelo envio do pacote SYN e da abertura de conexão:
echo 1 > /proc/sys/net/ipv4/conf/default/rp_filter
iptables -A INPUT -m state --state INVALID -j DROP

# Juntando tudo, teriamos:
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT
echo 0 > /proc/sys/net/ipv4/conf/all/accept_redirects
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
echo 0 > /proc/sys/net/ipv4/conf/all/accept_source_route
echo 0 > /proc/sys/net/ipv4/ip_forward
echo 1 > /proc/sys/net/ipv4/tcp_syncookies
echo 1 > /proc/sys/net/ipv4/conf/default/rp_filter
iptables -A INPUT -m state --state INVALID -j DROP
# Essas regras devemser adicionadas logo no inicio do script, de forma que sejam carregadas antes de qualquer regra que abra portas ou permita o acesso de endereços ou faixas de enredereços
