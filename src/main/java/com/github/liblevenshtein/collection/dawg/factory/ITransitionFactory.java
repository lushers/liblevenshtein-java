package com.github.liblevenshtein.collection.dawg.factory;

import java.io.Serializable;

import com.github.liblevenshtein.collection.dawg.IDawgNode;
import com.github.liblevenshtein.collection.dawg.Transition;

/**
 * Builds transitions that link nodes together, connected by a character label.
 * @param <NodeType> Kind of the nodes joined by transitions.
 * @author Dylon Edwards
 * @since 2.1.0
 */
public interface ITransitionFactory<NodeType extends IDawgNode<NodeType>> extends Serializable {

  long serialVersionUID = 1L;

  /**
   * Builds or recycles a {@link Transition} object representing an edge from
   * {@code source} to {@code target}, annotated with {@code label}.
   * @param source Node from which the transition is leaving.
   * @param label Label that joins {@code source} and {@code target} together.
   * @param target Node to which the transition is going.
   * @return A {@link Transition} linking {@code source} to {@code target},
   * under {@code label}.
   */
  Transition<NodeType> build(NodeType source, char label, NodeType target);

  /**
   * Recycles a {@link Transition} to be re-used from
   * {@link #build(IDawgNode,char,IDawgNode) build}.
   * @param transition {@link Transition} to recycle.  Note that once the
   * transition has been recycled, you should discard it (like a deleted
   * reference in C++).
   */
  default void recycle(final Transition<NodeType> transition) {
    // default behavior is to do nothing
  }
}