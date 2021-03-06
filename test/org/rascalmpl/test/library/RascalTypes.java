/*******************************************************************************
 * Copyright (c) 2009-2011 CWI
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:

 *   * Anastasia Izmaylova - A.Izmaylova@cwi.nl - CWI
*******************************************************************************/
package org.rascalmpl.test.library;

import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.junit.Test;
import org.rascalmpl.interpreter.types.FunctionType;
import org.rascalmpl.interpreter.types.RascalTypeFactory;
import org.rascalmpl.test.infrastructure.TestFramework;

import io.usethesource.vallang.random.RandomTypeGenerator;
import io.usethesource.vallang.type.Type;

public class RascalTypes extends TestFramework {
    
    private static class RascalTypeGenerartor extends RandomTypeGenerator {
        private final RascalTypeFactory rtf = RascalTypeFactory.getInstance();

        @Override
        public Type next(int maxDepth) {
            if (random.nextInt(6) != 0 || maxDepth < 2) {
                // most cases do the normal stuff
                return super.next(maxDepth);
            }
            // sometimes go for rascal types
            switch (random.nextInt(3)) {
                case 0:
                    return getFunctionType(maxDepth);
                case 1:
                    return getOverloadedFunctionType(maxDepth);
                case 2:
                default: // there is not other value, but java flow analyis can't see this.
                    return getReifiedType(maxDepth);
            }
        }
        
        public Type getFunctionType(int maxDepth) {
            return rtf.functionType(next(maxDepth), getTupleType(maxDepth), tf.voidType());
        }

        private List<Type> getTypeList(int maxDepth, int length) {
            List<Type> result = new ArrayList<>(length);
            for (int i = 0; i < length; i++) {
                result.add(next(maxDepth));
            }
            return result;
        }

        
        public Type getOverloadedFunctionType(int maxDepth) {
            Type returnType = next(maxDepth);
            List<Type> l = getTypeList(maxDepth, 2);
            Set<FunctionType> alternatives = new HashSet<FunctionType>();
            for(Type t : l) {
                if(t.isTuple()) {
                    alternatives.add((FunctionType)rtf.functionType(returnType, t, tf.voidType()));
                } else {
                    alternatives.add((FunctionType)rtf.functionType(returnType, tf.tupleType(t), tf.voidType()));
                }
            }
            return rtf.overloadedFunctionType(alternatives);
        }

        public Type getReifiedType(int maxDepth) {
            return rtf.reifiedType(next(maxDepth));
        }
    }
	
	@Test
	public void testLubAndGlb() {
		Set<Type> types = new HashSet<Type>();
		
		RascalTypeGenerartor rg = new RascalTypeGenerartor();
		
		for(int i = 0; i <= 1000; i++) {
			types.add(rg.getFunctionType(2));
			types.add(rg.getReifiedType(5));
			types.add(rg.getOverloadedFunctionType(2));
		}
		
		for (Type t : types) {
			if (t.lub(t) != t) {
				fail("lub should be idempotent: " + t + " != " + t.lub(t));
			}
		}

		for(Type t1 : types) {
			for(Type t2 : types) {
				Type lub1 = t1.lub(t2);
				Type lub2 = t2.lub(t1);

				if(lub1 != lub2) {
					System.err.println("Failure:");
					System.err.println(t1 + ".lub(" + t2 + ") = " + lub1);
					System.err.println(t2 + ".lub(" + t1 + ") = " + lub2);
					fail("lub should be commutative");
				}
				
				 if(t1.comparable(t2)) {
					 if (t1.isSubtypeOf(t2)) {
						 assertTrue(t1.lub(t2).equivalent(t2));
					 }
					 if(t2.isSubtypeOf(t1)) {
						 assertTrue(t1.lub(t2).equivalent(t1));
					 }
				 }
				 
				 if(t1 instanceof FunctionType
						 && t2 instanceof FunctionType && t1 != t2) {
					 FunctionType f1 = (FunctionType) t1;
					 FunctionType f2 = (FunctionType) t2;
					 Type lub = f1.lub(f2);
					 Type glb = f1.glb(f2);
					 // System.out.println("Checking subtyping: " + f1 + " and " + f2 + "; lub and glb: " + lub + ", " + glb);
					 if(f1.isSubtypeOf(f2)) {
						 assertTrue(f1.getReturnType().isSubtypeOf(f2.getReturnType()));
						 assertTrue(f2.getArgumentTypes().isSubtypeOf(f1.getArgumentTypes()));
					 }
					 if(f2.isSubtypeOf(f1)) {
						 assertTrue(f2.getReturnType().isSubtypeOf(f1.getReturnType()));
						 assertTrue(f1.getArgumentTypes().isSubtypeOf(f2.getArgumentTypes()));
					 } 
					 if(lub instanceof FunctionType) {
						 FunctionType flub = (FunctionType) lub;
						 assertTrue(f1.getReturnType().isSubtypeOf(flub.getReturnType()));
						 assertTrue(flub.getArgumentTypes().isSubtypeOf(f1.getArgumentTypes()));
						 assertTrue(f2.getReturnType().isSubtypeOf(flub.getReturnType()));
						 assertTrue(flub.getArgumentTypes().isSubtypeOf(f2.getArgumentTypes()));
					 }
					 if(glb instanceof FunctionType) {
						 FunctionType fglb = (FunctionType) glb;
						 assertTrue(fglb.getReturnType().isSubtypeOf(f1.getReturnType()));
						 assertTrue(f1.getArgumentTypes().isSubtypeOf(fglb.getArgumentTypes()));
						 assertTrue(fglb.getReturnType().isSubtypeOf(f2.getReturnType()));
						 assertTrue(f2.getArgumentTypes().isSubtypeOf(fglb.getArgumentTypes()));
					 }
				 }
			}
		}
		
		for(Type t : types) {
			if (t.glb(t) != t) {
				fail("glb should be idempotent: " + t + " != " + t.glb(t));
			}
		}

		for(Type t1 : types) {
			for(Type t2 : types) {
			    Type glb1 = t1.glb(t2);
			    Type glb2 = t2.glb(t1);

			   if(glb1 != glb2) {
			       System.err.println("Failure:");
			       System.err.println(t1 + ".glb(" + t2 + ") = " + glb1);
			       System.err.println(t2 + ".glb(" + t1 + ") = " + glb2);
			       fail("glb should be commutative");
			   }
			        
			   if(t1.comparable(t2)) {
			       if(t1.isSubtypeOf(t2)) {
			           assertTrue(t1.glb(t2).equivalent(t1));
			       }
			       if(t2.isSubtypeOf(t1)) {
			           assertTrue(t1.glb(t2).equivalent(t2));
			       }
			    }
			 }
		}

	}

}
