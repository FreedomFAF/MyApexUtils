public with sharing class JsonUtil {
    public JSONGenerator gen;

    public JsonUtil(){
        gen = JSON.createGenerator(true);
        gen.writeStartObject();
    }

    public JsonUtil(Boolean outerArray){
        gen = JSON.createGenerator(true);
        gen.writeStartArray();
    }

    public void startObject(String objectName){
        gen.writeFieldName(objectName);
        gen.writeStartObject();
    }

    public void startObject(){
        gen.writeStartObject();
    }

    public void endObject(){
        gen.writeEndObject();
    }

    public void newObject(){
        gen.writeEndObject();
        gen.writeStartObject();
    }

    public void startArray(String arrayName){
        gen.writeFieldName(arrayName);
        gen.writeStartArray();
    }

    public void startArray(){
        gen.writeStartArray();
    }

    public void endArray(){
        gen.writeEndArray();
    }

    public void add(String value){
        if (value == null){
            gen.writeNull();
        }else{
            gen.writeString(value);
        }
    }

    public void add(Integer value){
        if (value == null){
            gen.writeNull();
        }else{
            gen.writeNumber(value);
        }
    }

    public void add(Long value){
        if (value == null){
            gen.writeNull();
        }else{
            gen.writeNumber(value);
        }
    }

    public void add(Decimal value){
        if (value == null){
            gen.writeNull();
        }else{
            gen.writeNumber(value);
        }
    }

    public void add(Double value){
        if (value == null){
            gen.writeNull();
        }else{
            gen.writeNumber(value);
        }
    }

    public void put(String attributeName, String value){
        if (value == null){
            gen.writeNullField(attributeName);
        }else{
            gen.writeStringField(attributeName, value);
        }
    }

    public void put(String attributeName, Date value){
        if (value == null){
            gen.writeNullField(attributeName);
        }else{
            gen.writeDateField(attributeName, value);
        }
    }

    public void put(String attributeName, DateTime value){
        if (value == null){
            gen.writeNullField(attributeName);
        }else{
            gen.writeDateTimeField(attributeName, value);
        }
    }

    public void put(String attributeName, Integer value){
        if (value == null){
            gen.writeNullField(attributeName);
        }else{
            gen.writeNumberField(attributeName, value);
        }
    }

    public void put(String attributeName, Decimal value){
        if (value == null){
            gen.writeNullField(attributeName);
        }else{
            gen.writeNumberField(attributeName, value);
        }
    }

    public void put(String attributeName, Boolean value){
        if (value == null){
            gen.writeNullField(attributeName);
        }else{
            gen.writeBooleanField(attributeName, value);
        }
    }

    public void put(String attributeName, Time value){
        if (value == null){
            gen.writeNullField(attributeName);
        }else{
            gen.writeTimeField(attributeName, value);
        }
    }

    public String getAsString(){
        return gen.getAsString();
    }
}