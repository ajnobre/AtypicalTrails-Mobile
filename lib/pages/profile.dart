
import 'package:flutter/material.dart';


class ProfilePage extends StatelessWidget {

  TextStyle _style(){
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 19.0
    );
  }
  TextStyle _style2(){
    return TextStyle(
      fontSize: 16.0
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Name",style: _style()),
            SizedBox(height: 4,),
            Text("Octávio Nuno Jardim Freire", style: _style2(),),
            SizedBox(height: 16,),
            
            Text("Mobile", style: _style(),),
            SizedBox(height: 4,),
            Text("963135249", style: _style2(),),
            SizedBox(height: 16,),
            
            Text("Email", style: _style(),),
            SizedBox(height: 4,),
            Text("octavio@hotmail.com", style: _style2(),),
            SizedBox(height: 16,),

            Text("Address", style: _style(),),
            SizedBox(height: 4,),
            Text("Rua da fazendinha nº16 Santa Cruz - Madeira", style: _style2(),),
            SizedBox(height: 16,),

            Text("Password", style: _style(),),
            SizedBox(height: 4,),
            Text("1234556789", style: _style2(),),
            SizedBox(height: 16,),

            Divider(color: Colors.black54,)
          ],
        ),
      ),
    );
  }
}


final String photoPerfil = "https://i.kym-cdn.com/photos/images/newsfeed/000/787/356/d6f.jpg";


class CustomAppBar extends StatelessWidget
  with PreferredSizeWidget{

  @override
  Size get preferredSize => Size(double.infinity, 300);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyClipper(),
     child: SafeArea(
      child: Container(
        padding: EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
          color: Color(0xFF4CAF50),
          boxShadow: [
            BoxShadow(
              color: Colors.black54, //black45
              blurRadius: 15, //10
            )
          ]
        ),
        child: Column(
          children: <Widget>[
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.menu, color: Colors.white,
                  size: 35,),
                  onPressed: (){
                     print("//TODO: button clicked");
                  },
                ),

                Text("Profile", style: TextStyle(
                  color: Colors.white,
                  fontSize: 18
               ,)
               ,),
              
              Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: (){
                  print("//TODO: button clicked");
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                  
                    child: Container(
                      width: 90,
                      height: 32,
                      child: Center(child: Text("Edit Profile"),),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10
                          )
                        ]
                      ),
                    ),
                  ),
                ),
              ),
              ],
            ),
  Row(
     mainAxisAlignment: MainAxisAlignment.spaceAround, //moises na vertical dos principis
    children: <Widget>[

                Column(
                  children: <Widget>[         
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(photoPerfil)
                          )
                      ),
                    ),
                    SizedBox(height: 16,),
                    Text("@octaviojardim", style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      
                    ),)
                  ],
                ),
        
            Column(
             
              children: <Widget>[ 
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
            
                Column(
                  
                  children: <Widget>[
                    Text("Executed Trails", style: TextStyle(
                        color: Colors.white,
                         fontSize: 16,
                    ),),
                    Text("2", style: TextStyle(
                        fontSize: 24,
                        color: Colors.white
                    ),)
                  ],
                ),
                  SizedBox(width: 20),

                    Column(
                  children: <Widget>[
                    Text("Total Hours",
                    style: TextStyle(
                      color: Colors.white,
                       fontSize: 16,
                    ),),
                    Text("00:00", style: TextStyle(
                        color: Colors.white,
                        fontSize: 24
                    ))
                  ],
                ),
    
          ],),
      SizedBox(height: 30),
        Row(
            children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Points", style: TextStyle(
                      color: Colors.white,
                       fontSize: 16,
                    ),),
                    Text("20", style: TextStyle(
                      color: Colors.white,
                      fontSize: 24
                    ),)
                  ],
                ),

                SizedBox(width: 32),

                  Column(
                  children: <Widget>[
                    Text("Created Trails", style: TextStyle(
                      color: Colors.white,
                        fontSize: 16,
                    ),),
                    Text("8", style: TextStyle(
                        fontSize: 24,
                        color: Colors.white
                    ),)
                  ],
                ),

                ],),
                //SizedBox(width: 16,)

              ],
            ),    
        ],)
      ],)
                     
          
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path>{

  @override
  Path getClip(Size size) {
    Path p = Path();
   
    p.lineTo(0, size.height-10); //left

    var firstEndPoint = Offset(size.width *.5, size.height-30);
    var firstControlPoint = Offset(size.width *.25, size.height-50);
    p.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height-65); //right
    var secondControlPoint = Offset(size.width *.75, size.height-10);
    p.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    p.lineTo(size.width, 0);
    p.close();

    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}