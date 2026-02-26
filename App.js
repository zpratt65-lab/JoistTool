import React, { useState } from 'react';
import { StyleSheet, View, TextInput, Button, Text } from 'react-native';

export default function App() {
  const [span, setSpan] = useState('');
  const [result, setResult] = useState(null);

  const calculate = async () => {
    try {
      const response = await fetch('YOUR_FREE_HOST_URL/calculate-joist', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ span: parseFloat(span) }),
      });
      const data = await response.json();
      setResult(data.recommendedJoist);
    } catch (e) {
      setResult("Error connecting to Delphi Backend");
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>New Millennium Joist Tool</Text>
      <TextInput 
        placeholder="Enter Span (ft)" 
        keyboardType="numeric"
        onChangeText={setSpan}
        style={styles.input}
      />
      <Button title="Get Designation" onPress={calculate} color="#005a9c" />
      {result && <Text style={styles.result}>Recommended: {result}</Text>}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, justifyContent: 'center', padding: 20, backgroundColor: '#f4f4f4' },
  title: { fontSize: 22, fontWeight: 'bold', color: '#005a9c', marginBottom: 20, textAlign: 'center' },
  input: { borderWidth: 1, borderColor: '#ccc', padding: 10, marginBottom: 20, borderRadius: 5, backgroundColor: '#fff' },
  result: { marginTop: 30, fontSize: 18, fontWeight: 'bold', textAlign: 'center' }
});