void drawButton(String label,float x,float y,float w,float h){
  if(mouseX>x && mouseX<x+w && mouseY>y && mouseY<y+h){
    fill(200,200,200);
  }else{
    fill(150,150,150);
  }

  stroke(0);
  rect(x,y,w,h,8);

  fill(0);
  textAlign(CENTER,CENTER);
  textSize(14);
  text(label,x+w/2,y+h/2);
}

void checkButton(float x,float y,float w,float h){
  if(mouseX>x && mouseX<x+w && mouseY>y && mouseY<y+h){
    buttonIsOver=true;
  }else{
    buttonIsOver=false;
  }
}
