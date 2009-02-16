package org.meta_environment.rascal.ast; 
import org.eclipse.imp.pdb.facts.INode; 
public abstract class Comprehension extends AbstractAST { 
  public org.meta_environment.rascal.ast.Expression getResult() { throw new UnsupportedOperationException(); } public java.util.List<org.meta_environment.rascal.ast.Expression> getGenerators() { throw new UnsupportedOperationException(); } public boolean hasResult() { return false; } public boolean hasGenerators() { return false; } public boolean isSet() { return false; }
static public class Set extends Comprehension {
/* "{" result:Expression "|" generators:{Expression ","}+ "}" -> Comprehension {cons("Set")} */
	private Set() { }
	/*package*/ Set(INode node, org.meta_environment.rascal.ast.Expression result, java.util.List<org.meta_environment.rascal.ast.Expression> generators) {
		this.node = node;
		this.result = result;
		this.generators = generators;
	}
	public <T> T accept(IASTVisitor<T> visitor) {
		return visitor.visitComprehensionSet(this);
	}

	public boolean isSet() { return true; }

	public boolean hasResult() { return true; }
	public boolean hasGenerators() { return true; }

private org.meta_environment.rascal.ast.Expression result;
	public org.meta_environment.rascal.ast.Expression getResult() { return result; }
	private void $setResult(org.meta_environment.rascal.ast.Expression x) { this.result = x; }
	public Set setResult(org.meta_environment.rascal.ast.Expression x) { 
		Set z = new Set();
 		z.$setResult(x);
		return z;
	}
	private java.util.List<org.meta_environment.rascal.ast.Expression> generators;
	public java.util.List<org.meta_environment.rascal.ast.Expression> getGenerators() { return generators; }
	private void $setGenerators(java.util.List<org.meta_environment.rascal.ast.Expression> x) { this.generators = x; }
	public Set setGenerators(java.util.List<org.meta_environment.rascal.ast.Expression> x) { 
		Set z = new Set();
 		z.$setGenerators(x);
		return z;
	}	
}
static public class Ambiguity extends Comprehension {
  private final java.util.List<org.meta_environment.rascal.ast.Comprehension> alternatives;
  public Ambiguity(INode node, java.util.List<org.meta_environment.rascal.ast.Comprehension> alternatives) {
	this.alternatives = java.util.Collections.unmodifiableList(alternatives);
         this.node = node;
  }
  public java.util.List<org.meta_environment.rascal.ast.Comprehension> getAlternatives() {
	return alternatives;
  }
  
  public <T> T accept(IASTVisitor<T> v) {
     return v.visitComprehensionAmbiguity(this);
  }
} public boolean isList() { return false; }
static public class List extends Comprehension {
/* "[" result:Expression "|" generators:{Expression ","}+ "]" -> Comprehension {cons("List")} */
	private List() { }
	/*package*/ List(INode node, org.meta_environment.rascal.ast.Expression result, java.util.List<org.meta_environment.rascal.ast.Expression> generators) {
		this.node = node;
		this.result = result;
		this.generators = generators;
	}
	public <T> T accept(IASTVisitor<T> visitor) {
		return visitor.visitComprehensionList(this);
	}

	public boolean isList() { return true; }

	public boolean hasResult() { return true; }
	public boolean hasGenerators() { return true; }

private org.meta_environment.rascal.ast.Expression result;
	public org.meta_environment.rascal.ast.Expression getResult() { return result; }
	private void $setResult(org.meta_environment.rascal.ast.Expression x) { this.result = x; }
	public List setResult(org.meta_environment.rascal.ast.Expression x) { 
		List z = new List();
 		z.$setResult(x);
		return z;
	}
	private java.util.List<org.meta_environment.rascal.ast.Expression> generators;
	public java.util.List<org.meta_environment.rascal.ast.Expression> getGenerators() { return generators; }
	private void $setGenerators(java.util.List<org.meta_environment.rascal.ast.Expression> x) { this.generators = x; }
	public List setGenerators(java.util.List<org.meta_environment.rascal.ast.Expression> x) { 
		List z = new List();
 		z.$setGenerators(x);
		return z;
	}	
} public abstract <T> T accept(IASTVisitor<T> visitor); public org.meta_environment.rascal.ast.Expression getFrom() { throw new UnsupportedOperationException(); }
	public org.meta_environment.rascal.ast.Expression getTo() { throw new UnsupportedOperationException(); } public boolean hasFrom() { return false; }
	public boolean hasTo() { return false; } public boolean isMap() { return false; }
static public class Map extends Comprehension {
/* "(" from:Expression ":" to:Expression "|" generators:{Expression ","}+ ")" -> Comprehension {cons("Map")} */
	private Map() { }
	/*package*/ Map(INode node, org.meta_environment.rascal.ast.Expression from, org.meta_environment.rascal.ast.Expression to, java.util.List<org.meta_environment.rascal.ast.Expression> generators) {
		this.node = node;
		this.from = from;
		this.to = to;
		this.generators = generators;
	}
	public <T> T accept(IASTVisitor<T> visitor) {
		return visitor.visitComprehensionMap(this);
	}

	public boolean isMap() { return true; }

	public boolean hasFrom() { return true; }
	public boolean hasTo() { return true; }
	public boolean hasGenerators() { return true; }

private org.meta_environment.rascal.ast.Expression from;
	public org.meta_environment.rascal.ast.Expression getFrom() { return from; }
	private void $setFrom(org.meta_environment.rascal.ast.Expression x) { this.from = x; }
	public Map setFrom(org.meta_environment.rascal.ast.Expression x) { 
		Map z = new Map();
 		z.$setFrom(x);
		return z;
	}
	private org.meta_environment.rascal.ast.Expression to;
	public org.meta_environment.rascal.ast.Expression getTo() { return to; }
	private void $setTo(org.meta_environment.rascal.ast.Expression x) { this.to = x; }
	public Map setTo(org.meta_environment.rascal.ast.Expression x) { 
		Map z = new Map();
 		z.$setTo(x);
		return z;
	}
	private java.util.List<org.meta_environment.rascal.ast.Expression> generators;
	public java.util.List<org.meta_environment.rascal.ast.Expression> getGenerators() { return generators; }
	private void $setGenerators(java.util.List<org.meta_environment.rascal.ast.Expression> x) { this.generators = x; }
	public Map setGenerators(java.util.List<org.meta_environment.rascal.ast.Expression> x) { 
		Map z = new Map();
 		z.$setGenerators(x);
		return z;
	}	
}
}