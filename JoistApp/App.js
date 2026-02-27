import React, { useState } from 'react';
import { StyleSheet, View, TextInput, Button, Text } from 'react-native';

export default function App() {
  const [series, setSeries] = useState('K');
  const [methodology, setMethodology] = useState('ASD');
  const [span, setSpan] = useState('');
  const [deadLoad, setDeadLoad] = useState('');
  const [liveLoad, setLiveLoad] = useState('');
  const [spacing, setSpacing] = useState('');
  const [result, setResult] = useState(null);

  const HOST = process.env.EXPO_PUBLIC_API_HOST || 'https://joisttool.onrender.com'; 

  const calculate = async () => {
    try {
      const response = await fetch(`${HOST}/calculate-joist`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          joist_series: series,
          design_methodology: methodology,
          span: parseFloat(span) || 0,
          dead_load: parseFloat(deadLoad) || 0,
          live_load: parseFloat(liveLoad) || 0,
          joist_spacing: parseFloat(spacing) || 0,
        }),
      });
      const data = await response.json();
      setResult(data);
    } catch (e) {
      setResult({ error: 'Error connecting to Delphi Backend' });
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>New Millennium Joist Tool</Text>
      <TextInput 
        placeholder="Joist Series (e.g. K)" 
        onChangeText={setSeries}
        value={series}
        style={styles.input}
      />
      <TextInput 
        placeholder="Design Methodology (ASD or LRFD)" 
        onChangeText={setMethodology}
        value={methodology}
        style={styles.input}
      />
      <TextInput 
        placeholder="Span (ft)" 
        keyboardType="numeric"
        onChangeText={setSpan}
        value={span}
        style={styles.input}
      />
      <TextInput 
        placeholder="Dead Load (psf)" 
        keyboardType="numeric"
        onChangeText={setDeadLoad}
        value={deadLoad}
        style={styles.input}
      />
      <TextInput 
        placeholder="Live Load (psf)" 
        keyboardType="numeric"
        onChangeText={setLiveLoad}
        value={liveLoad}
        style={styles.input}
      />
      <TextInput 
        placeholder="Joist Spacing (ft)" 
        keyboardType="numeric"
        onChangeText={setSpacing}
        value={spacing}
        style={styles.input}
      />
      <Button title="Calculate Joist" onPress={calculate} color="#005a9c" />
      {result && !result.error && (
        <View style={styles.resultContainer}>
          <Text style={styles.result}>Designation: {result.joist_designation}</Text>
          <Text style={styles.result}>Self‑weight: {result.joist_self_weight}</Text>
          <Text style={styles.result}>Bridging Rows: {result.bridging_rows_required}</Text>
          <Text style={styles.result}>Min Bearing Seat: {result.min_bearing_seat_depth}</Text>
          <Text style={styles.result}>Total Safe Load: {result.total_safe_load}</Text>
        </View>
      )}
      {result && result.error && <Text style={styles.error}>{result.error}</Text>}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, justifyContent: 'center', padding: 20, backgroundColor: '#f4f4f4' },
  title: { fontSize: 22, fontWeight: 'bold', color: '#005a9c', marginBottom: 20, textAlign: 'center' },
  input: { borderWidth: 1, borderColor: '#ccc', padding: 10, marginBottom: 20, borderRadius: 5, backgroundColor: '#fff' },
  result: { marginTop: 30, fontSize: 18, fontWeight: 'bold', textAlign: 'center' },
  resultContainer: { marginTop: 20 },
  error: { marginTop: 20, fontSize: 16, color: 'red', textAlign: 'center' }
});