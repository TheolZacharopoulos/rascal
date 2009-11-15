package org.meta_environment.rascal.library.experiments.VL;

import org.eclipse.imp.pdb.facts.IConstructor;
import org.meta_environment.rascal.interpreter.IEvaluatorContext;
import org.meta_environment.rascal.library.experiments.Processing.SketchSWT;

import processing.core.PApplet;

public class VL  {

	public static void render(IConstructor velem, IEvaluatorContext ctx){
		PApplet pa = new VLPApplet(velem, ctx);
		new SketchSWT(pa);
	}
}


