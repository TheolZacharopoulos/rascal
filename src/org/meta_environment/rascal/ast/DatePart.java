package org.meta_environment.rascal.ast; 
import org.eclipse.imp.pdb.facts.INode; 
public abstract class DatePart extends AbstractAST { 
  static public class Lexical extends DatePart {
	private final String string;
         public Lexical(INode node, String string) {
		this.node = node;
		this.string = string;
	}
	public String getString() {
		return string;
	}

 	public <T> T accept(IASTVisitor<T> v) {
     		return v.visitDatePartLexical(this);
  	}
} static public class Ambiguity extends DatePart {
  private final java.util.List<org.meta_environment.rascal.ast.DatePart> alternatives;
  public Ambiguity(INode node, java.util.List<org.meta_environment.rascal.ast.DatePart> alternatives) {
	this.alternatives = java.util.Collections.unmodifiableList(alternatives);
         this.node = node;
  }
  public java.util.List<org.meta_environment.rascal.ast.DatePart> getAlternatives() {
	return alternatives;
  }
  
  public <T> T accept(IASTVisitor<T> v) {
     return v.visitDatePartAmbiguity(this);
  }
} public abstract <T> T accept(IASTVisitor<T> visitor);
}