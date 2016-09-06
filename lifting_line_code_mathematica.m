(* ::Package:: *)

(* ::Title:: *)
(*M\[EAcute]todo de Glauert*)


(* ::Text:: *)
(*Con el comando set option, elejimos opciones por defecto para una funci\[OAcute]n. En este caso, la funci\[OAcute]n es ListPlot, que es la funci\[OAcute]n que usamos para graficar una lista de puntos.*)


(* ::Input:: *)
(*SetOptions[ListPlot, AspectRatio-> 0.4, Filling->Axis, ClippingStyle->Red, PlotMarkers->Automatic, Mesh->All,Joined->True];*)


(* ::Text:: *)
(*Definimos los parametros del ala. Atenci\[OAcute]n, se recomienda no usar subindices en el nombre de las variables, como Subscript[twist, 0.75], ya que muchas veces tiene un comportamiento inesperado.*)


(* ::Input:: *)
(*V\[Infinity]=150;(*[m]*)*)
(*\[Alpha] = 5 * \[Pi]/180; (*[rad]*)*)
(*b = 15; (*[m]*)*)
(*Sw = 10;(*[(m^2)]*)*)
(*twist075=-1*\[Pi]/180;(*[rad]*)*)
(*\[Lambda]= 0.7;*)
(*Cr=2*Sw/b/(\[Lambda]+1);(*[m]*)*)


(* ::Text:: *)
(*Definimos los parametros del perfil (en este caso, no hay alabeo aerodinamico, pero incluirlo seria extender lo realizado para el alabeo geometrico y la cuerda, para a y Subscript[\[Alpha], 0])*)


(* ::Input:: *)
(*a=2\[Pi] ;(*[1/rad]*)*)
(*\[Alpha]0=1.5*\[Pi]/180;(*[rad]*)*)


(* ::Text:: *)
(*Selecionamos la cantidad de puntos para discretizar la envergadura. Atenci\[OAcute]n: los puntos ubicados sobre la puntera generan indeterminaci\[OAcute]nes. Esto se soluciona corriendolos hacia el centro del ala. La distrubuci\[OAcute]n de los puntos se hace siguiendo una ley cosenoidal, para lograr asi una distribuci\[OAcute]n lineal de \[Theta]. Usamos el comando Table para generar la lista de puntos.*)


(* ::Input:: *)
(*n=50;*)
(*eta = Table[N[-Cos[(2*y/b+1)*\[Pi]/2]*b/2],{y,-b/2,b/2,b/(n-1)}]; *)
(*eta[[1]] = (0.75*eta[[1]]+0.25*eta[[2]]);*)
(*eta[[-1]] = (0.75*eta[[-1]]+0.25*eta[[-2]]);*)
(*eta*)


(* ::Text:: *)
(*Usamos Table tambien para generar la distribuci\[OAcute]n de alabeo geometrico y cuerda. Prestar atenci\[OAcute]n a la forma en que se le indica para que valores de y evaluar la expresi\[OAcute]n.*)


(* ::Input:: *)
(*twist = Table[Abs[2*y/b]*twist075*4/3,{y,eta}];*)
(*chord = Table[Cr*(1-(1-\[Lambda])*2*Abs[y]/b),{y,eta}];*)


(* ::Text:: *)
(*Para graficar una lista de puntos, usamos el comando ListPlot. Pero el este comando espera una lista de pares x,y {{Subscript[x, 1],Subscript[y, 1]},{Subscript[x, 2],Subscript[y, 2]},{Subscript[x, 3],Subscript[y, 3]},...,{Subscript[x, n],Subscript[y, n]}}, pero disponemos de dos listas separadas {Subscript[x, 1],Subscript[x, 2],Subscript[x, 3,]... , Subscript[x, n]} y {Subscript[y, 1,] Subscript[y, 2],Subscript[y, 3],... , Subscript[y, n]}. Para pasar de un formato a otro, usamos el comando MapThread.*)


(* ::Input:: *)
(*ListPlot[MapThread[List,{eta,twist}],AxesLabel->{"y","Twist[rad]"}, Filling-> Axis, Mesh-> All, Joined->True]*)
(*ListPlot[MapThread[List,{eta,chord}],AxesLabel->{"y","Chord[m]"}, Filling-> Axis, Mesh-> All, Joined->True]*)
(**)


(* ::Text:: *)
(*Con todos los datos cargados, armamos las matrices m y B, que nos permiten resolver el sistema de ecuaciones m * A = B, donde A es el vector de coeficientes de la serie senoidal que usamos para aproximar \[CapitalGamma]. Resolvemos el sistema de ecuaciones usando el comando LinearSolve.*)


(* ::Input:: *)
(*theta = Table[ArcCos[-2*y/b],{y,eta}];*)
(*m=Table[Table[Sin[j theta[[i]]] ((4 b )/(a chord[[i]] Sin[theta[[i]]])+j),{j,1,n}],{i,1,n}];*)
(*B = Table[((\[Alpha]-\[Alpha]0)+twist[[i]])*Sin[theta[[i]]],{i,1,n}]; *)
(*A = LinearSolve[m,B]*)


(* ::Text:: *)
(*Reconstruimos \[CapitalGamma] y Subscript[\[Alpha], i].*)


(* ::Input:: *)
(*\[CapitalGamma]=Table[0,{i,1,n}];*)
(*\[Alpha]i=Table[0,{i,1,n}];*)
(*For[i=1,i<=n,i++,*)
(*\[CapitalGamma]=\[CapitalGamma]+A[[i]]*Sin[i * theta]; *)
(*\[Alpha]i=\[Alpha]i+ i*A[[i]]*Sin[i*theta]/Sin[theta];*)
(*]*)


(* ::Text:: *)
(*Agregamos manualmente los puntos de la puntera, sabiendo que la circulaci\[OAcute]n en la puntera debe ser nula, y el angulo inducido igual al angulo de incidencia local. *)


(* ::Input:: *)
(*\[CapitalGamma]=Prepend[\[CapitalGamma],0]; \[CapitalGamma]=Append[\[CapitalGamma],0];*)
(*\[Alpha]i=Prepend[\[Alpha]i,\[Alpha]-\[Alpha]0+twist[[0]]]; \[Alpha]i=Append[\[Alpha]i,\[Alpha]-\[Alpha]0+twist[[0]]];*)
(*eta=Prepend[eta,-b/2];eta=Append[eta,b/2];*)
(**)


(* ::Input:: *)
(*ListPlot[MapThread[List,{eta,\[CapitalGamma]}],AxesLabel->{"y","\[CapitalGamma]"}, Filling-> Axis, Mesh-> All, Joined->True]*)
(*ListPlot[MapThread[List,{eta,\[Alpha]i}],AxesLabel->{"y","\[Alpha]i"}, Filling-> Axis, Mesh-> All, Joined->True]*)


(* ::Text:: *)
(*Integramos numericamente \[CapitalGamma] y \[CapitalGamma]*Subscript[\[Alpha], i] para obtener L y Subscript[D, i].*)


(* ::Input:: *)
(*L = NIntegrate[Interpolation[MapThread[List,{eta,\[CapitalGamma]}],InterpolationOrder->2][y],{y,-b/2,b/2}]*2*b*V\[Infinity]*)


(* ::Input:: *)
(*Di= NIntegrate[Interpolation[MapThread[List,{eta,\[CapitalGamma]*\[Alpha]i}],InterpolationOrder->2][y],{y,-b/2,b/2}]*2*b*V\[Infinity]*)


(* ::Text:: *)
(*Estos resultados se pueden validar empleando las formulas planteadas en clase a partir de los coeficientes Subscript[A, i]*)
