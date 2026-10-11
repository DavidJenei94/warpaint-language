# Device update 2.0.5

The existing 2.0.5 release already supports the 14 new profiles. Its code/build is unchanged by this documentation update. `resources-round-466x466` contains 78 x 47 flags, 39 x 23 small flags, a 109 x 109 logo and percentage-based layouts. Forerunner 55 remains excluded for stability.

## Simulator debug checklist

Inspect `fenix9pro51mm` language selection, flags, long translations, reveal/next controls, statistics and glance. The 466 x 466 binary and complete 219-variant release were compiled and signature-verified in the prior release step.

## Device support policy

Garmin compatibility alone does not enable a product. The manifest is the released support list. Match its app type, shape, resolution and memory, then apply the project's settings and annotation overlays. The workbook's support column follows this list exactly.

The public Description sheet is derived from the README's public description, features, FAQ, release notes and permissions. Development/build sections remain in Markdown. Device specifications come from the installed Garmin SDK compiler/simulator profiles and Garmin's official compatible-device/device-reference pages; feature availability also follows the app overlays. The local `.xlsx` is the maintained help artifact; copying it to Google Sheets remains a separate publication step.

Sources checked 2026-10-11:
- https://developer.garmin.com/connect-iq/compatible-devices/
- https://developer.garmin.com/connect-iq/device-reference/

## Release validation

Use `powershell -NoProfile -File scripts/build-release.ps1` with Java 17+ and the installed Connect IQ SDK. It keeps the original app ID/type and `../developer_key`, exports every manifest product and verifies the signed manifest, binary signatures and exact firmware/regional coverage. The versioned upload file, log and SHA-256 checksum are in `dist`.
