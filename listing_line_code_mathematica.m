(* ::Package:: *)

(* ::Input:: *)
(*SetOptions[ListPlot, AspectRatio-> 0.4, Filling->Axis, ClippingStyle->Red, PlotMarkers->Automatic, Mesh->All,Joined->True];*)


(* ::Input:: *)
(*V\[Infinity]=150;(*[m]*)*)
(*\[Alpha] = 5 * \[Pi]/180; (*[rad]*)*)
(*b = 15; (*[m]*)*)
(*Sw = 10;(*[m^2]*)*)
(*twist075=-1*\[Pi]/180;(*[rad]*)*)
(*\[Lambda]= 0.7;*)
(*Cr=2*Sw/b/(\[Lambda]+1);(*[m]*)*)


(* ::Input:: *)
(*a=5.7;(*[1/rad]*)*)
(*\[Alpha]0=1.5*\[Pi]/180;(*[rad]*)*)


(* ::Input:: *)
(*n=10;*)
(*eta = Table[N[-Cos[(2*y/b+1)*\[Pi]/2]*b/2],{y,-b/2,b/2,b/(n-1)}]; *)
(*eta[[1]] = (0.75*eta[[1]]+0.25*eta[[2]]);*)
(*eta[[-1]] = (0.75*eta[[-1]]+0.25*eta[[-2]]);*)
(*eta*)


(* ::Input:: *)
(*twist = Table[Abs[2*y/b]*twist075*4/3,{y,eta}];*)
(*chord = Table[Cr*(1-(1-\[Lambda])*2*Abs[y]/b),{y,eta}];*)
(*ListPlot[MapThread[List,{eta,twist}],AxesLabel->{"y","Chord"}, Filling-> Axis, Mesh-> All, Joined->True]*)
(*ListPlot[MapThread[List,{eta,chord}],AxesLabel->{"y","twist"}, Filling-> Axis, Mesh-> All, Joined->True]*)


(* ::Input:: *)
(*theta = Table[ArcCos[-2*y/b],{y,eta}];*)
(*m=Table[Table[Sin[j theta[[i]]] ((4 b )/(a chord[[i]] Sin[theta[[i]]])+j),{j,1,n}],{i,1,n}];*)
(*B = Table[((\[Alpha]-\[Alpha]0)+twist[[i]])*Sin[theta[[i]]],{i,1,n}]; *)
(*A = LinearSolve[m,B]*)


(* ::Input:: *)
(*\[CapitalGamma]=Table[0,{i,1,n}];*)
(*\[Alpha]i=Table[0,{i,1,n}];*)
(*For[i=1,i<=n,i++,*)
(*\[CapitalGamma]=\[CapitalGamma]+A[[i]]*Sin[i * theta]; *)
(*\[Alpha]i=\[Alpha]i+ i*A[[i]]*Sin[i*theta]/Sin[theta];*)
(*]*)


(* ::Input:: *)
(*\[CapitalGamma]=Prepend[\[CapitalGamma],0]; \[CapitalGamma]=Append[\[CapitalGamma],0];*)
(*\[Alpha]i=Prepend[\[Alpha]i,\[Alpha]-\[Alpha]0+twist[[0]]]; \[Alpha]i=Append[\[Alpha]i,\[Alpha]-\[Alpha]0+twist[[0]]];*)
(*eta=Prepend[eta,-b/2];eta=Append[eta,b/2];*)
(**)


(* ::Input:: *)
(*ListPlot[MapThread[List,{eta,\[CapitalGamma]}],AxesLabel->{"y","\[CapitalGamma]"}, Filling-> Axis, Mesh-> All, Joined->True]*)
(*ListPlot[MapThread[List,{eta,\[Alpha]i}],AxesLabel->{"y","\[Alpha]i"}, Filling-> Axis, Mesh-> All, Joined->True]*)


(* ::Input:: *)
(*L = NIntegrate[Interpolation[MapThread[List,{eta,\[CapitalGamma]}],InterpolationOrder->2][y],{y,-b/2,b/2}]*2*b*V\[Infinity]*)


(* ::Input:: *)
(*Di= NIntegrate[Interpolation[MapThread[List,{eta,\[CapitalGamma]*\[Alpha]i}],InterpolationOrder->2][y],{y,-b/2,b/2}]*2*b*V\[Infinity]*)
