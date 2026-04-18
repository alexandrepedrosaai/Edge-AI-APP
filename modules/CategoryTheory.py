"""
CategoryTheory Module
Category Theory mathematical abstractions and compositions for Edge-AI-APP.
Models functors, morphisms, and natural transformations for pipeline composition.
"""

import sys
import json
from functools import reduce


class Object:
    """A category-theoretic object."""
    def __init__(self, name):
        self.name = name

    def __repr__(self):
        return f"Obj({self.name})"


class Morphism:
    """A morphism (arrow) between two objects."""
    def __init__(self, name, source, target, func):
        self.name = name
        self.source = source
        self.target = target
        self.func = func

    def apply(self, x):
        return self.func(x)

    def __repr__(self):
        return f"Morph({self.name}: {self.source} -> {self.target})"


class Category:
    """A simple category with objects and morphisms."""
    def __init__(self, name):
        self.name = name
        self.objects = {}
        self.morphisms = []

    def add_object(self, name):
        obj = Object(name)
        self.objects[name] = obj
        return obj

    def add_morphism(self, name, source_name, target_name, func):
        m = Morphism(name, source_name, target_name, func)
        self.morphisms.append(m)
        return m

    def compose(self, f: Morphism, g: Morphism):
        """Compose morphisms: g ∘ f (apply f first, then g)."""
        assert f.target == g.source, f"Cannot compose: {f.target} != {g.source}"
        composed_func = lambda x: g.apply(f.apply(x))
        return Morphism(
            f"({g.name} ∘ {f.name})",
            f.source,
            g.target,
            composed_func,
        )


def build_ml_pipeline_category():
    """Model an ML pipeline as a category."""
    cat = Category("MLPipeline")

    # Objects: data types at each stage
    cat.add_object("RawData")
    cat.add_object("NormalizedData")
    cat.add_object("Features")
    cat.add_object("Embeddings")
    cat.add_object("Predictions")

    # Morphisms: transformations
    normalize = cat.add_morphism(
        "normalize", "RawData", "NormalizedData",
        lambda x: [(v - min(x)) / (max(x) - min(x) + 1e-8) for v in x]
    )
    extract = cat.add_morphism(
        "extract_features", "NormalizedData", "Features",
        lambda x: [v ** 2 for v in x]
    )
    embed = cat.add_morphism(
        "embed", "Features", "Embeddings",
        lambda x: [sum(x[i:i+2]) / 2 for i in range(0, len(x), 2)]
    )
    predict = cat.add_morphism(
        "predict", "Embeddings", "Predictions",
        lambda x: [1 if v > 0.5 else 0 for v in x]
    )

    return cat, [normalize, extract, embed, predict]


def main():
    print("Initializing CategoryTheory module...")

    cat, morphisms = build_ml_pipeline_category()

    print(f"Category: {cat.name}")
    print(f"Objects: {list(cat.objects.keys())}")
    print("Morphisms:")
    for m in morphisms:
        print(f"  {m}")

    # Compose the full pipeline
    pipeline = morphisms[0]
    for m in morphisms[1:]:
        pipeline = cat.compose(pipeline, m)

    print(f"\nComposed pipeline: {pipeline}")

    # Apply to sample data
    raw_data = [3.0, 1.0, 4.0, 1.0, 5.0, 9.0, 2.0, 6.0]
    result = pipeline.apply(raw_data)
    print(f"Input:  {raw_data}")
    print(f"Output: {result}")

    # Functor: map between categories (identity functor example)
    print("\nFunctor (identity): mapping objects to themselves")
    for obj_name in cat.objects:
        print(f"  F({obj_name}) = {obj_name}")

    output = {
        "module": "CategoryTheory",
        "version": "1.0.0",
        "category": cat.name,
        "objects": list(cat.objects.keys()),
        "morphisms": [m.name for m in morphisms],
        "pipeline": pipeline.name,
        "sample_output": result,
        "status": "success",
    }
    print("\nCategoryTheory JSON output:")
    print(json.dumps(output, indent=2))

    print("\nCategoryTheory module completed successfully.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
