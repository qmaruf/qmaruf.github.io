Extracting complex data such as one or multiple dates from text can be tedious and time-consuming, especially when dealing with long articles or documents. Fortunately, using language models like Llama, we can automate this process. This blog post will show you how to extract dates from a passage of text using the Llama model with Ollama, and we’ll walk through the code step-by-step.

---

#### **Step 1: Install and Set Up Ollama**

First, you need to install Ollama, a tool that allows you to run large language models, like Llama, locally. Run the following command to install it:

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

After installation, you can run the Llama model locally by executing:

```bash
ollama run llama3.1
```

This sets up the environment for using Llama to handle the text extraction task.

---

#### **Step 2: Define the Date and Dates Classes**

Before jumping into the extraction process, we need to structure our data. The `Date` class represents individual dates, while the `Dates` class holds a list of these dates.

```python
class Date(BaseModel):
    """
    Represents a date with day, month, and year.
    """
    day: int = Field(description="Day of the month")
    month: int = Field(description="Month of the year")
    year: int = Field(description="Year")

class Dates(BaseModel):
    """
    Represents a list of dates (Dates class).
    """
    dates: List[Date] = Field(..., description="List of dates.")
```

These classes allow us to store each date with the day, month, and year clearly defined.

---

#### **Step 3: Set Up the DatesExtractor Class**

Next, we create the `DatesExtractor` class, which handles the process of extracting dates from the text. The class initializes a prompt, which instructs the Llama model to find and return the dates in a structured JSON format. Here's how the class is structured:

```python
class DatesExtractor:
    """
    Extracts dates from a given passage and returns them in JSON format.
    """
    def __init__(self, model_name: str = "llama3.1", temperature: float = 0):
        self.prompt = ChatPromptTemplate.from_messages(
            [
                (
                    "system",
                    "You are a helpful AI assistant. Extract dates from the given passage and return them in JSON format.",
                ),
                (
                    "user",
                    "Identify the dates from the passage and extract the day, month and year. Return the dates as a JSON object with a 'dates' key containing a list of date objects. Each date object should have 'day', 'month', and 'year' keys. Return the number of month, not name. Here is the text: {passage}",
                ),
            ]
        )

        self.llm = ChatOllama(model=model_name, temperature=temperature)
        self.output_parser = JsonOutputParser()
        self.chain = self.prompt | self.llm | self.output_parser
```

In this section, we define the AI’s behavior through a prompt. The AI is instructed to extract dates from the text, ensuring that each date is formatted with day, month (as a number), and year, and returned as a JSON object.

---

#### **Step 4: Extracting Dates from a Passage**

Once the `DatesExtractor` class is set up, we define the `extract` method, which takes a passage of text as input, processes it through the Llama model, and returns the extracted dates.

```python
    def extract(self, passage: str) -> Dates:
        try:
            response = self.chain.invoke({"passage": passage})
            return Dates(**response)
        except Exception as e:
            logger.error(f"Error in extracting dates: {e}")
            return None
```

The `extract` method calls the AI model with the given text and captures the result. It returns the dates in a structured format, or logs an error if something goes wrong during processing.

---

#### **Step 5: Running the Date Extractor**

To see the code in action, let’s extract dates from a passage that contains various date formats:

```python
if __name__ == "__main__":
    passage = "The history of the automobile is marked by key milestones. Karl Benz built the first car on 29/01/1886, revolutionizing transportation. Later, on June 8th, 1948, Porsche unveiled its iconic 356 model. In 1964-04-17, Ford introduced the Mustang, forever changing the sports car industry. Electric cars gained momentum, with Tesla's Model S launched on July 22, 2012."

    extractor = DatesExtractor()
    dates: Dates = extractor.extract(passage)
    for date in dates.dates:
        print(date)
```

In this passage, we have dates in different formats such as `dd/mm/yyyy`, `dd/mmm/yyyy`, and `yyyy-mm-dd`. When we run the extractor, the AI will return each of these dates in a standardized JSON format.

The output of this code looks like:

```python
day=29 month=1 year=1886
day=8 month=6 year=1948
day=17 month=4 year=1964
day=22 month=7 year=2012
```

---

#### **Conclusion**

Using the combination of Ollama and Llama, extracting dates from text is simple and efficient. By structuring the data using Pydantic models and leveraging powerful AI tools, we can easily handle date extraction tasks in various formats. Whether you're working with historical data, articles, or other documents, this approach allows for a smooth and scalable solution to date extraction.

#### **Code** 
The full code is available [here](https://github.com/qmaruf/LLM/blob/main/data_extraction/main.py)