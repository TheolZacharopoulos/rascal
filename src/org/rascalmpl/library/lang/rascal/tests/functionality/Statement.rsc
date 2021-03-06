@license{
  Copyright (c) 2009-2015 CWI
  All rights reserved. This program and the accompanying materials
  are made available under the terms of the EclipseLicense v1.0
  which accompanies this distribution, and is available at
  http://www.eclipse.org/legal/epl-v10.html
}
@contributor{Jurgen J. Vinju - Jurgen.Vinju@cwi.nl - CWI}
@contributor{Paul Klint - Paul.Klint@cwi.nl - CWI}
@contributor{Bert Lisser - Bert.Lisser@cwi.nl - CWI}
module lang::rascal::tests::functionality::Statement
  
import Exception;

// testAssert
  
test bool testAssert1() {return assert 3 > 2;}
test bool testAssert2() {return assert 3 > 2: "Yes assert succeeds";}
  	   
@expected{AssertionFailed}
test bool assertError1() {assert 1 == 2;return false;}

@expected{AssertionFailed}
test bool assertError2() {assert 1 == 2: "1 really differs from 2"; return false;}
  
// assignment
  
test bool assignment1() {int x = 3; return x == 3;}
test bool assignment2() {int x = 3; x = 4; return  x == 4;}
test bool assignment3() {return {<x, y> = <3, 4>; (x == 3) && (y == 4);};}
test bool assignment4() {return {<x, y, z> = <3, 4, 5>; (x == 3) && (y == 4) && (z == 5);};}
test bool assignment5() {return {<x, y> = <3, 4>; x = 5; return (x == 5) && (y == 4);};}
  
test bool assignment6() {int x = 3; x += 2; return x == 5;}
test bool assignment7() {int x = 3; x -= 2; return x == 1;}
test bool assignment8() {int x = 3; x *= 2; return x == 6;}
test bool assignment9() {int x = 3; x /= 2; return x == 1;}
  		
test bool assignment10() {list[int] x = [0,1,2]; return x == [0,1,2];}
test bool assignment11() {list[int] x = [0,1,2]; return x[0] == 0;}
test bool assignment12() {list[int] x = [0,1,2]; return x[1] == 1;}
test bool assignment13() {list[int] x = [0,1,2]; return  x[2] == 2;}
test bool assignment14() {return {list[int] x = [0,1,2]; x[1] = 10; (x[0] == 0) && (x[1] == 10) && (x[2] == 2);};}
  
test bool assignment15() {return {map[int,int] x = (0:0,1:10,2:20); x == (0:0,1:10,2:20);};}
test bool assignment16() {return {map[int,int] x = (0:0,1:10,2:20); x[1] = 15; (x[0] == 0) && (x[1] == 15) && (x[2] == 20);};}
  
test bool assignment17() {set[int] x = {0,1,2}; return x == {0,1,2};}
test bool assignment18() {set[int] x = {0,1,2}; x = x + {3,4}; return x == {0,1,2, 3,4};}
  
test bool assignment19() {rel[str,list[int]] s = {<"a", [1,2]>, <"b", []>, <"c", [4,5,6]>}; return s != {};}
test bool assignment20() {rel[str,list[int]] s = {<"a", [1,2]>, <"b", []>, <"c", [4,5,6]>};return s != {};}
  
// block
  
test bool block1() {int x = 3; x = 4; return x ==4;}
test bool block2() {int x = 3; x = 4; return x == 4;}
  
// testBreak
  
test bool testBreak() {int n = 0; while(n < 10){ n = n + 1; break;}; return n == 1;}
  
  
// testContinue
  
  	    /* no tests available */
  
// doWhile
  
test bool doWhile1() {return {int n = 0; m = 2; do {m = m * m; n = n + 1;} while (n < 1); (n == 1) && (m == 4);};}
test bool doWhile2() {return {int n = 0; m = 2; do {m = m * m; n = n + 1;} while (n < 3); m == 256;};}
  	
// testWhile
  
test bool testWhile1() {return {int n = 0; int m = 2; while(n != 0){ m = m * m;}; (n == 0)&& (m == 2);};}
test bool testWhile2() {return {int n = 0; int m = 2; while(n < 3){ m = m * m; n = n + 1;}; (n ==3) && (m == 256);};}

test bool testWhileWithBacktracking1() {
    list[list[int]] res = [];
    l:while([*int x, *int _] := [1,2,3]) {
        res = res + [ x ];
        fail l;
    }
    return res ==  [[],[1],[1,2],[1,2,3]];
}

test bool testWhileWithBacktracking2() {
    list[list[int]] res = [];
    
    while(true) {
        res = res + [ [999] ];
        fail;
    }
    return res == [[999]];
}

test bool testWhileWithBacktracking3(){
    list[list[int]] res = [];
   
    n = 0;
    while([*int x, *int y] := [3,4,3,4], n < 3) {
        if(x == y) {
            res = res + [ x ];
            n = n + 1;
        } else {
            res = res + [ [0] ];
            fail;
        }
    }
    return res ==  [[0],[0],[3,4],[0],[0],[3,4],[0],[0],[3,4]];
}

test bool testWhileWithBacktracking4(){
    list[list[int]] res = [];

    n = 0;
    while(n < 3) {
        res = res + [ [10] ];
        n = n + 1;
    }
    return res == [[10],[10],[10]];
}

test bool testWhileWithBacktracking5(){
    list[list[int]] res = [];

    n = 0;
    while(1 == 1, n < 3) {
        res = res + [ [11] ];
        n = n + 1;
    }
    return res == [[11],[11],[11]];
}

test bool testWhileWithBacktracking6(){
    list[list[int]] res = [];

    n = 0;
    while(1 == 2 || n < 3) {
        res = res + [ [12] ];
        n = n + 1;
    }
    return res ==  [[12],[12],[12]];
}

@ignoreCompiler{FIX: pre and post should be reset to undefined on loop entry}
test bool testWhileWithPatternVariables(){
    syms = [10,9,1,3,5];
    while([*pre, x, y, *post] := syms, x > y){
      syms = [*pre, y, x, *post];
    }
    return syms == [1,3,5,9,10];
}
 	
data D = d(int i) | d();
  
D d(int i) { if (i % 2 == 0) fail d; else return d();}
  
// fail
  
test bool fail1() = d(2) := d(2);
test bool fail2() = d(3) == d();

test bool fail3() {
    int n = 0; 
    loop:for(int _ <- [1,2,3,4], n <= 3) { 
        if(n == 3) {
            fail loop;
        } 
        n = n + 1; 
    } 
    return n == 3;
}

test bool fail4() {
	int main(){
	    if1:if(x <- [1,2,3,4], x <= 3) {
	        if2:if(y <- [4,3,2,1], y >= 3) {
	            if(x != 3) {
	                fail if1;
	            } else if(y != 3) {
	                fail if2;
	            }
	            return x + y;
	        }
	    }
	    return -1;
    }
    return main() == 6;
}

test bool fail5() {
    str trace = "";
    if(true) {
        if(false) {
           ;
        } else {
           trace += "fail inner!";
           fail;
        }
    } else {
        trace += "else outer!";
    }
    return trace == "fail inner!else outer!";
}
  		
// testFor
  
test bool testFor1() {int n = 0; for(int i <- [1,2,3,4]){ n = n + i;} return n == 10;}
test bool testFor2() {int n = 0; for(int i <- [1,2,3,4], n <= 3){ n = n + i;} return n == 6;}
test bool testFor3() {int n = 0; for(int _ <- [1,2,3,4]){ n = n + 1; if (n == 3) break; } return n == 3;}
test bool testFor4() {int n = 0; for(int _ <- [1,2,3,4], n <= 3){ if (n == 3) continue; n = n + 1; } return n == 3;}
test bool testFor5() {int n = 0; loop:for(int _ <- [1,2,3,4], n <= 3){ if (n == 3) fail loop; n = n + 1; } return n == 3;}
  
// testAppend

/*TODO:?*/
//test bool testAppend() for(int i <- [1,2,3,4]){ 3 * i; } == 12;));
test bool testAppend1() { L = for(int i <- [1,2,3,4]){ append 3 * i; }; return L == [3,6,9,12];}
test bool testAppend2() { L = for(int i <- [1,2,3,4]){ append 3 * i; append 4 *i;}; return L == [3,4,6,8,9,12,12,16];}

test bool testAppend3() {
    res1 = for(2 > 1) append 0;
    res1 = res1 + [ 1 | 2 > 1 ];
    res2 = for(2 < 1) append 2;
    res2 = res2 + [ 3 | 2 < 1 ];
    return res1 + res2 == [0, 1];
}

// We no longer allow dynamically scoped appends
//test bool testAppend4() {
//    res = for(x <- [1,2,3,4]) { int f() { append x; return 4; }; append f(); };
//    return res == [1,4,2,4,3,4,4,4];
//}

// ifThen
  
test bool ifThen1() {int n = 10; if(n < 10){n = n - 4;} return n == 10;}
test bool ifThen2() {int n = 10; if(n < 15){n = n - 4;} return n == 6;}
test bool ifThen3() {int n = 10; l:if(int i <- [1,2,3]){ if (i % 2 != 0) { n = n + 4; fail l; } n = n - 4;} return n == 10;}

// ifThenElse
  
test bool ifThenElse1() {int n = 10; if(n < 10){n = n - 4;} else { n = n + 4;} return n == 14;}
test bool ifThenElse2() {int n = 12; if(n < 10){n = n - 4;} else { n = n + 4;} return n == 16;}
  
// testSwitch
  
test bool testSwitch1a() {int n = 0; switch(2){ case 2: n = 2; case 4: n = 4; case 6: n = 6; default: n = 10;} return n == 2;}
test bool testSwitch1b() {int n = 0; switch(4){ case 2: n = 2; case 4: n = 4; case 6: n = 6; default: n = 10;} return n == 4;}
test bool testSwitch1c() {int n = 0; switch(6){ case 2: n = 2; case 4: n = 4; case 6: n = 6; default: n = 10;} return n == 6;}
test bool testSwitch1d() {int n = 0; switch(8){ case 2: n = 2; case 4: n = 4; case 6: n = 6; default: n = 10;} return n == 10;}
test bool testSwitch1e() {int n = 0; switch(8){ default: ;} return n == 0;}
test bool testSwitch1f() {int n = 0; switch(8){ default: n = 10;} return n == 10;}
 
 int sw2(int e){ 	
 	int n = 0;
 	switch(e){
 		case 1 : 		n = 1;
 		case _: 2: 		n = 2;
 		case int _:	3: 	n = 3;
 		default: 		n = 4;
 	}
 	return n;
 }	
 
 test bool testSwitch2a() = sw2(1) == 1;
 test bool testSwitch2b() = sw2(2) == 2;
 test bool testSwitch2c() = sw2(3) == 3;
 test bool testSwitch2d() = sw2(4) == 4;
 
 int sw3(str e){ 	
 	int n = 0;
 	switch(e){
 		case "abc": n = 1;
 		case /A/: n = 2;
 		case str _: "def": n = 3;
 		default: n = 4;
 	}
 	return n;
 }
 
 test bool testSwitch3a() = sw3("abc") == 1;
 test bool testSwitch3b() = sw3("AAA") == 2;
 test bool testSwitch3c() = sw3("def") == 3;
 test bool testSwitch3d() = sw3("zzz") == 4;
 	
 int sw4(value e){ 	
 	int n = 0;
 	switch(e){
 		case "abc": 		n = 1;
		case str _: /def/: 	n = 2;
		case 3: 			n = 3;
		case d(): 			n = 4;
		case d(_): 			n = 5;
		case str _(3): 		n = 6;
		case [1,2,3]: 		n = 7;
		case [1,2,3,4]: 	n = 8;
		default: 			n = 9;
 	}
 	return n;
 }
 
 test bool testSwitch4a() = sw4("abc") 		== 1;
 test bool testSwitch4b() = sw4("def") 		== 2;
 test bool testSwitch4c() = sw4(3)     		== 3;
 test bool testSwitch4d() = sw4(d())   		== 4;
 test bool testSwitch4e() = sw4(d(2))  		== 5;
 test bool testSwitch4f() = sw4("abc"(3))	== 6;
 test bool testSwitch4g() = sw4([1,2,3]) 	== 7;
 test bool testSwitch4h() = sw4([1,2,3,4]) 	== 8;
 test bool testSwitch4i() = sw4(<-1,-1>) 	== 9;
 
 data E = e() | e(int n) | e(str s, int m);
 
 int sw5(value v){
 	int n = 0;
 	switch(v){
		case "abc": 							n = 1;
		case e(/<s:^[A-Za-z0-9\-\_]+$>/, 2): 	 { n = 2; if (str _ := s /* just use the s to avoid warning */) true; }
		case e(/<s:^[A-Za-z0-9\-\_]+$>/, 3): 	 { n = 3; if (str _ := s) true; }
		case 4: 								n = 4;
		case e(): 								n = 5;
		case e(int _): 							n = 6;
		case str _(7): 							n = 7;
		case [1,2,3]: 							n = 8;
		case [1,2,3,4]:							n = 9;
		case e("abc", 10): 						n = 10;
		case e("abc", int _): 					n = 11;
		case node _: 							n = 12;
		default: 								n = 13;
	}
	return n;
}

test bool testSwitch5a() = sw5("abc") 		== 1;
test bool testSwitch5b() = sw5(e("abc",2))	== 2;
test bool testSwitchdc() = sw5(e("abc",3))	== 3;
test bool testSwitch5e() = sw5(4)			== 4;
test bool testSwitch5f() = sw5(e())			== 5;
test bool testSwitch5g() = sw5(e(6))		== 6;
test bool testSwitch5h() = sw5(e(7))		== 6;
test bool testSwitch5i() = sw5("f"(7))		== 7;
test bool testSwitch5j() = sw5([1,2,3])		== 8;
test bool testSwitch5k() = sw5([1,2,3,4])	== 9;
test bool testSwitch5l() = sw5(e("abc",10))	== 10;
test bool testSwitch5m() = sw5(e("abc",11))	== 11;
test bool testSwitch5n() = sw5("f"(12))		== 12;
test bool testSwitch5o() = sw5(13)			== 13;
  	
int sw6(value v){
 	int n = 0;
 	switch(v){
		case true: 								n = 1;
		case 2: 								n = 2;
		case 3.0:					 			n = 3;
		case 4r3: 								n = 4;
		case |home:///|:						n = 5;	
		case $2015-02-11T20:09:01.317+00:00$: 	n = 6;
		case "abc": 							n = 7;
		case [1,2,3]: 							n = 8;
		case [<1,2,3>]:							n = 9;
		case {1,2,3}:							n = 10;
		case {<1,2,3>}:							n = 11;
		//case ("a" : 1): 						n = 12;
		default: 								n = 13;
	}
	return n;
}

@ignoreInterpreter{Location, datetime and map pattern not supported}
test bool testSwitch6a() = sw6(true)		== 1;

@ignoreInterpreter{Location, datetime and map pattern not supported}
test bool testSwitch6b() = sw6(2)			== 2;
@ignoreInterpreter{Location, datetime and map pattern not supported}
test bool testSwitch6c() = sw6(3.0)			== 3;
@ignoreInterpreter{Location, datetime and map pattern not supported}
test bool testSwitch6d() = sw6(4r3)			== 4;
@ignoreInterpreter{Location, datetime and map pattern not supported}
test bool testSwitch6e() = sw6(|home:///|)	== 5;
@ignoreInterpreter{Location, datetime and map pattern not supported}
test bool testSwitch6f() = sw6($2015-02-11T20:09:01.317+00:00$)		
											== 6;
@ignoreInterpreter{Location, datetime and map pattern not supported}
test bool testSwitch6g() = sw6("abc")		== 7;
@ignoreInterpreter{Location, datetime and map pattern not supported}
test bool testSwitch6h() = sw6([1,2,3])		== 8;
@ignoreInterpreter{Location, datetime and map pattern not supported}
test bool testSwitch6i() = sw6([<1,2,3>])	== 9;
@ignoreInterpreter{Location, datetime and map pattern not supported}
test bool testSwitch6j() = sw6({1,2,3})		== 10;
@ignoreInterpreter{Location, datetime and map pattern not supported}
test bool testSwitch6k() = sw6({<1,2,3>})	== 11;
@ignore{map pattern not supported}
test bool testSwitch6l() = sw6(("a" : 1))	== 12;
@ignoreInterpreter{Location, datetime and map pattern not supported}
test bool testSwitch6m() = sw6(13)			== 13;
@ignoreInterpreter{Location, datetime and map pattern not supported}



//  solve

rel[int,int] R1 =  {<1,2>, <2,3>, <3,4>};
  
test bool solve1() {
  		  rel[int,int] T =    R1;
  		  solve (T)  T = T + (T o R1);
  		  return T == {<1,2>, <1,3>,<1,4>,<2,3>,<2,4>,<3,4>};
}	
  
test bool solve2() {
  		  int j = 0;
  		  solve (j) if (j < 1000) j += 1;
  		  return j == 1000;
}	
        
@expected{IndexOutOfBounds}
test bool solveIndexOutOfBounds1() {
  			  rel[int,int] T =    R1;
  		  solve (T; -1)  T = T + (T o R1);
    		return T == {<1,2>, <1,3>,<1,4>,<2,3>,<2,4>,<3,4>};
		}
		
rel[int,int] removeIdPairs(rel[int,int] inp){
   res = inp;
   solve(res) {
         if ( { < a, b >, < b, b >, *c } := res ) 
              res = { *c, < a, b > };
   }
   return res;
}
 
test bool removeIdPairs1() = removeIdPairs({}) == {};
test bool removeIdPairs2() = removeIdPairs({<1,2>,<2,3>}) == {<1,2>,<2,3>};
test bool removeIdPairs3() = removeIdPairs({<1,2>,<2,3>,<2,2>}) == {<1,2>,<2,3>};
test bool removeIdPairs4() = removeIdPairs({<1,2>,<2,2>,<2,3>,<3,3>}) == {<1,2>,<2,3>};
test bool removeIdPairs5() = removeIdPairs({<2,2>,<1,2>,<2,2>,<2,3>,<3,3>}) == {<1,2>,<2,3>};
test bool removeIdPairs6() = removeIdPairs({<2,2>,<3,3>,<1,2>,<2,2>,<2,3>,<3,3>}) == {<1,2>,<2,3>};