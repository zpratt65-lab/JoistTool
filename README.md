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
  "design_methodology": "ASD",
  "span": 24.5,
  "dead_load": 10.0,
  "live_load": 20.0,
  "joist_spacing": 4.0
}
```

> All keys listed above are optional – the service will apply defaults when a
> value is missing (see **API fields** section).

- Response (JSON):

```json
{
  "recommendedJoist": "12K3",
  "selfWeight": 15.2,
  "maxSpacing": 5.0
}
```

The current implementation still returns a mock recommendation based on span
(and ignores the other inputs):

- span ≤ 20 ft → `10K1`
- span > 20 ft → `12K3`


### API fields

| HTML ID | JSON Key | Data Type | Description |
|---------|----------|-----------|-------------|
| design_methodology | design_methodology | String | ASD or LRFD |
| span               | span               | Float  | Length in feet |
| dead_load          | dead_load          | Float  | Weight of materials (psf) |
| live_load          | live_load          | Float  | Moving/temporary loads (psf) |
| joist_spacing      | joist_spacing      | Float  | Distance between joists (ft) |

## Implementation notes

- The backend contains simplified structural logic intended for demonstration; production systems should rely on verified SJI tables and engineering rules.
- See `Dockerfile` for build steps and tool choices.

