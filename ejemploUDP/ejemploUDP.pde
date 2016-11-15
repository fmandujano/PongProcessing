import hypermedia.net.*;


UDP udpServer;
UDP udpCliente;

boolean arriba;
boolean abajo;


int posicionY;

boolean init=false;

void setup()
{
  size(200,200);
    
  udpCliente = new UDP(this);
  //udpCliente.listen();
  init = true;
  
  posicionY = 100;
}

void draw()
{
  if(arriba)
  {
    posicionY--;
  }
  if(abajo)
  {
    posicionY++;
  }
  

  udpCliente.send(""+posicionY, "127.0.0.1", 50001 );
  
  background(255,255,255);
  //dibujar una barra
  fill(250,0,0);
  rect(10, posicionY, 15, 60);
}

void keyPressed()
{
  if(key=='w') arriba =true;
  if(key=='s') abajo =true;
}

void keyReleased()
{
  if(key=='w') arriba =false;
  if(key=='s') abajo =false;
}