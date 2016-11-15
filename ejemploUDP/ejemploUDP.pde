import hypermedia.net.*;

int PORT = 6666;
String IP = "172.200.1.23";
UDP udpServer;
UDP udpCliente;

boolean enMenu=true;
boolean esServidor;

boolean arriba;
boolean abajo;

int vel = 10;
int posJugLocal;
int posJugRemoto;
PVector posPelota;
PVector velPelota;

PFont fuente;

boolean init=false;

void setup()
{
  size(800,600);
  
  fuente = createFont("Arial", 32);

  init = true;
  posJugLocal = 100;
  posJugRemoto = 100;//-10000;
  posPelota = new PVector(width/2, height/2);
  velPelota = new PVector(0,0);
}

void draw()
{
  if(arriba)
  {
    posJugLocal -= vel;
  }
  if(abajo)
  {
    posJugLocal += vel;
  }
  
  if(enMenu)
    drawMenu();
  else
  {
    if(esServidor)
       procesarServidor();
     else
       procesarCliente();
  
    background(128,128,128);
    //dibujar jugador local
    fill(0,250,0);
    rect(10, posJugLocal, 15, 60);
    //dibujar jugador remoto
    fill(250,0,0);
    rect(width-25, posJugRemoto, 15, 60);
    
    //dibujar pelota
    fill(255,255,0);
    ellipse(posPelota.x, posPelota.y, 25,25);  
  }
}

void procesarServidor()
{
  //procesar el movimiento de la pelota
  procesarPelota();
  //println("sendmsg");
  String mensaje = posJugLocal+","+posPelota.x+","+posPelota.y;
  udpCliente.send(mensaje, IP, PORT+1);
  //procesar la info del lciente
}

void procesarCliente()
{
  String mensaje = posJugLocal+"";
  udpCliente.send(mensaje, IP, PORT);
}

void procesarPelota()
{
  posPelota.x += velPelota.x * 0.030f;
  posPelota.y += velPelota.y * 0.030f;
  
  //choque con paredes
  if(posPelota.x + 25 > width)
  {
    velPelota.x *= -1;
  }
  if(posPelota.x - 25 < 0)
  {
    velPelota.x *= -1;
  }
  if(posPelota.y - 25 < 0)
  {
    velPelota.y *= -1;
  }
  if(posPelota.y + 25 > height)
  {
    velPelota.y *= -1;
  }
}


void receive(byte [] data, String ip, int port)
{
  String msg = new String(data);
  if(esServidor)
  {
    //lo unico que hay que leer es la posiciion del remoto
    posJugRemoto = Integer.parseInt(msg);
    //println(msg);
  }
  else
  {
    //hay que analizar la posicion del remoto y la pelota
    //println(msg);
    String[] list = split(msg, ',');
    posJugRemoto = Integer.parseInt(list[0]);
    posPelota.x = Float.parseFloat(list[1]);
    posPelota.y = Float.parseFloat(list[2]);
  }
}

void drawMenu()
{
  textFont(fuente, 32);
  text("Elige 1 pasa servidor o 2 para cliente", 20,50);
}

void keyPressed()
{
  if(enMenu)
  {
    if(key=='1') //serviddor
    {
      udpServer = new UDP(this, PORT);
      udpServer.listen(true);
      udpCliente = new UDP(this);
      enMenu = false;
      esServidor = true;
      velPelota = new PVector(100,100);
    }
    if(key=='2') //cliente
    {
      udpCliente = new UDP(this);
      udpServer = new UDP(this, PORT+1);
      udpServer.listen(true);
      enMenu = false;
      esServidor = false;
      
    }
  }
  else
  {
  
    if(key=='w') arriba =true;
    if(key=='s') abajo =true;
  }
}

void keyReleased()
{
    if(enMenu)
  {
    
  }
  else
  {
    if(key=='w') arriba =false;
    if(key=='s') abajo =false;
  }
}