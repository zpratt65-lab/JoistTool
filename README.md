## JoistAPI

A minimal API created as an interview project to model parts of NewMill's Standard Joist Tools.

## Summary

- Frontend: React Native (Expo)
- Backend: Object Pascal / Delphi (Free Pascal Compiler)
- Framework: Horse (Delphi/Pascal web framework)
- Packaging: Docker (multi-stage build)

## Quickstart

From the `JoistAPI` folder, build and run the containerized backend:

```powershell
docker build -t joist-api .
docker run --rm -p 9000:9000 joist-api
```

The API listens on port 9000 (example endpoint below).

## API (example)

- Endpoint: `POST /calculate-joist`
- Payload (JSON):

```json
{
  "span": 24.5
}
```

- Response (JSON):

```json
{
  "recommendedJoist": "12K3"
}
```

The current implementation returns a mock recommendation based on span:

- span ≤ 20ft → `10K1`
- span > 20ft → `12K3`

## Implementation notes

- The backend contains simplified structural logic intended for demonstration; production systems should rely on verified SJI tables and engineering rules.
- See `Dockerfile` for build steps and tool choices.

