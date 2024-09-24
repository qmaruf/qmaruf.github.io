Dunder methods (short for "double underscore methods") are special methods in Python that have double underscores (`__`) before and after their names. They define how objects of a class behave when used with built-in operations such as `print()`, indexing, comparisons, or mathematical operations. Here's a breakdown of some common dunder methods and how you can use them to customize your Python objects.

---

## 1. `__init__` – The Constructor

The `__init__` method is the constructor of a class and is called when you create a new instance. This is where you can initialize attributes for the object.

```python
class Person:
    def __init__(self, name):
        self.name = name

p = Person("Sarah")
print(p.name)  # Outputs: Sarah
```

**Explanation**: In this example, we define a `Person` class with a constructor that takes a name as an argument. When an instance of the `Person` class is created, the `__init__` method is called to initialize the `name` attribute.

---

## 2. `__str__` – String Representation for Humans

The `__str__` method controls how an object is printed or represented as a string using `print()` or `str()`.

```python
class Person:
    def __init__(self, name):
        self.name = name

    def __str__(self):
        return f"Person: {self.name}"

p = Person("Sarah")
print(p)  # Outputs: Person: Sarah
```

**Explanation**: Here, the `__str__` method provides a human-readable representation of the object. When you print the object, it displays `"Person: Sarah"` instead of the default representation like `<Person object at 0x...>`.

---

## 3. `__repr__` – String Representation for Developers

The `__repr__` method is like `__str__` but is meant to provide a detailed, unambiguous string that can be used for debugging.

```python
class Person:
    def __init__(self, name):
        self.name = name

    def __repr__(self):
        return f"Person({self.name!r})"

p = Person("Sarah")
print(repr(p))  # Outputs: Person('Sarah')
```

**Explanation**: The `__repr__` method provides a string that shows exactly how to recreate the object, making it helpful for debugging.

---

## 4. `__len__` – Define Object Length

If you want to define a length for your object, implement the `__len__` method, which is used by the `len()` function.

```python
class Group:
    def __init__(self, members):
        self.members = members

    def __len__(self):
        return len(self.members)

g = Group(["Sarah", "John", "Alice"])
print(len(g))  # Outputs: 3
```

**Explanation**: The `__len__` method returns the length of the group, which is the number of members. Here, `len(g)` gives us 3.

---

## 5. `__getitem__` – Access Items with Indexing

The `__getitem__` method allows your object to be indexed like a list or dictionary.

```python
class Group:
    def __init__(self, members):
        self.members = members

    def __getitem__(self, index):
        return self.members[index]

g = Group(["Sarah", "John", "Alice"])
print(g[1])  # Outputs: John
```

**Explanation**: The `__getitem__` method defines how the object should behave when accessed with square brackets (e.g., `g[1]`).

---

## 6. `__setitem__` – Set Items with Indexing

The `__setitem__` method defines how an object’s item can be updated via indexing.

```python
class Group:
    def __init__(self):
        self.members = {}

    def __setitem__(self, key, value):
        self.members[key] = value

g = Group()
g[0] = "Sarah"
print(g.members)  # Outputs: {0: 'Sarah'}
```

**Explanation**: Here, we can assign values to `g` using indexing, and the `__setitem__` method updates the `members` dictionary.

---

## 7. `__delitem__` – Delete Items with Indexing

The `__delitem__` method allows you to delete an item from the object using `del`.

```python
class Group:
    def __init__(self, members):
        self.members = members

    def __delitem__(self, index):
        del self.members[index]

g = Group(["Sarah", "John", "Alice"])
del g[1]
print(g.members)  # Outputs: ['Sarah', 'Alice']
```

**Explanation**: The `__delitem__` method is called when you delete an item from the object using `del`.

---

## 8. `__call__` – Make Objects Callable

If you want an object to behave like a function, implement the `__call__` method.

```python
class Greet:
    def __call__(self, name):
        return f"Hello, {name}!"

greet = Greet()
print(greet("Sarah"))  # Outputs: Hello, Sarah!
```

**Explanation**: Here, the `Greet` object can be called like a function because of the `__call__` method.

---

## 9. `__eq__` – Equality Comparison

The `__eq__` method defines how two objects should be compared for equality using `==`.

```python
class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __eq__(self, other):
        return self.x == other.x and self.y == other.y

p1 = Point(1, 2)
p2 = Point(1, 2)
print(p1 == p2)  # Outputs: True
```

**Explanation**: The `__eq__` method compares two `Point` objects for equality by checking their `x` and `y` values.

---

## 10. `__lt__` – Less Than Comparison

The `__lt__` method allows you to define how one object should be compared to another using the less-than operator (`<`).

```python
class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __lt__(self, other):
        return (self.x + self.y) < (other.x + other.y)

p1 = Point(1, 2)
p2 = Point(2, 3)
print(p1 < p2)  # Outputs: True
```

**Explanation**: The `__lt__` method compares two `Point` objects by their combined `x` and `y` values.

---

## 11. `__add__` – Define Addition Behavior

The `__add__` method allows you to define how objects should behave when added with the `+` operator.

```python
class Vector:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __add__(self, other):
        return Vector(self.x + other.x, self.y + other.y)

    def __repr__(self):
        return f"Vector({self.x}, {self.y})"

v1 = Vector(1, 2)
v2 = Vector(3, 4)
print(v1 + v2)  # Outputs: Vector(4, 6)
```

**Explanation**: The `__add__` method enables the addition of two `Vector` objects by adding their `x` and `y` values together.

---

## 12. `__enter__` and `__exit__` – Context Managers

These methods define the behavior of an object when used in a `with` statement, allowing for setup and teardown logic.

```python
class File:
    def __init__(self, filename, mode):
        self.filename = filename
        self.mode = mode

    def __enter__(self):
        self.file = open(self.filename, self.mode)
        return self.file

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.file.close()

with File("example.txt", "w") as f:
    f.write("Hello, World!")
```

**Explanation**: The `__enter__` method opens the file, and the `__exit__` method ensures the file is closed, even if an error occurs.

---

## 13. `__contains__` – Define `in` Keyword Behavior

The `__contains__` method defines how the `in` keyword works for your object.

```python
class Group:
    def __init__(self, members):
        self.members = members

    def __contains__(self, item):
        return item in self.members

g = Group(["Sarah", "John", "Alice"])
print("John" in g)  # Outputs: True
```

**Explanation**: The `__contains__` method allows you to check if an item is in the `Group` using the `in` keyword.

---

## 14. `__iter__` – Make Objects Iterable

The `__iter__` method makes your object iterable so it can be used in a `for` loop.

```python
class Group:
    def __init__(self, members):


        self.members = members

    def __iter__(self):
        return iter(self.members)

g = Group(["Sarah", "John", "Alice"])
for member in g:
    print(member)
# Outputs: Sarah, John, Alice
```

**Explanation**: The `__iter__` method allows the `Group` object to be used in a loop to iterate over its members.

---

These are just some of the many dunder methods available in Python. They give you a lot of control over how objects behave and interact with Python's built-in functionality, making your code more flexible and powerful.
You can execute all the code in this google colab [notebook](https://colab.research.google.com/drive/16bV5gWqGxhaDAitb-lsNjP7r6EVS4ShD?usp=sharing).