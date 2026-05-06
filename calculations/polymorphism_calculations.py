
class Animal:
    def speak(self):
        raise NotImplementedError("Subclass must implement abstract method")

class Dog(Animal):
    def speak(self):
        return "Woof!"

class Cat(Animal):
    def speak(self):
        return "Meow!"

class Cow(Animal):
    def speak(self):
        return "Moo!"

def make_animal_speak(animal):
    return animal.speak()

dog = Dog()
cat = Cat()
cow = Cow()

print(f"Dog says: {make_animal_speak(dog)}")
print(f"Cat says: {make_animal_speak(cat)}")
print(f"Cow says: {make_animal_speak(cow)}")
