package com.github.liblevenshtein.collection.dictionary.factory;

import java.io.Serializable;

import it.unimi.dsi.fastutil.chars.Char2ObjectMap;
import it.unimi.dsi.fastutil.chars.Char2ObjectRBTreeMap;

import com.github.liblevenshtein.collection.dictionary.DawgNode;
import com.github.liblevenshtein.collection.dictionary.FinalDawgNode;

/**
 * Builds nodes for use in DAWG structures. This implementation uses an object
 * pool to avoid unnecessary memory consumption and garbage collection.
 *
 * @author Dylon Edwards
 * @since 2.1.0
 */
public class DawgNodeFactory implements IDawgNodeFactory<DawgNode>, Serializable {

  private static final long serialVersionUID = 1L;

  /**
   * {@inheritDoc}
   */
  @Override
  public DawgNode build() {
    return build(false);
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public DawgNode build(final boolean isFinal) {
    final Char2ObjectMap<DawgNode> edges = new Char2ObjectRBTreeMap<>();

    if (isFinal) {
      return new FinalDawgNode(edges);
    }

    return new DawgNode(edges);
  }
}