# Mobile API Contract

This page records the endpoints and payload shapes currently used by the Flutter app's data sources. The backend remains the source of truth for validation and response schemas; inspect the backend Swagger UI at `/api/docs` when changing a contract.

## Base URL and authentication

`API_BASE_URL` must include the backend `/api` prefix and must not end with a slash. The app's default is `https://mahder-api.duckdns.org/api`.

```env
API_BASE_URL=https://your-api-host.example/api
```

The Dio interceptor adds `Authorization: Bearer <access-token>` to requests when a token is stored. It refreshes expiring tokens with `POST /iam/auth/refresh-token` and the `refresh_token` body field. Authentication routes are excluded from the automatic authorization header. Successful backend responses are read from the `data` property of the response envelope.

On an Android emulator, use the host address reachable from that emulator. On a physical device, use the computer's LAN address or a reachable HTTPS API host; `localhost` on the phone refers to the phone itself.

## Authentication and account setup

All paths below are relative to `API_BASE_URL`.

| Method | Path | Request used by the app |
|---|---|---|
| `POST` | `/iam/users/sign-up` | `{ "phone_number": "<phone>" }` |
| `POST` | `/iam/users/verify/{verificationId}` | `{ "phone": "<phone>", "code": "<otp>" }` |
| `PATCH` | `/iam/users` | Registration profile fields: `first_name`, `middle_name`, `last_name`, `email`, `password`, `birth_date`, `gender`, `dialect_id`, `language_id` |
| `POST` | `/iam/auth/mobile_login` | `{ "username": "<phone>", "password": "<password>", "device_token": "<device-token>", "device_type": "android" }` |
| `POST` | `/iam/auth/refresh-token` | `{ "refresh_token": "<refresh-token>" }` |
| `POST` | `/iam/auth/forgot-password` | `{ "username": "<phone>" }` |
| `POST` | `/iam/auth/verify-otp` | `{ "username": "<phone>", "code": "<otp>" }` |
| `POST` | `/iam/auth/reset-password` | `{ "username": "<phone>", "code": "<otp>", "password": "<new-password>" }` |

The login response is read from `data.user`, `data.access_token`, and `data.refresh_token`. The app formats contributor phone logins with the `+251` country code before sending the request. The current login implementation sends the literal `device_token` value `string` and `device_type` value `android`; these are implementation placeholders, not a working device-token registration flow.

## Tasks and submissions

| Method | Path | Request details |
|---|---|---|
| `GET` | `/task-distribution/my-tasks` | Query parameters `page`, `limit`, and optional uppercase `status` |
| `GET` | `/task-distribution/assigned-tasks/{taskId}` | Task detail for the assigned task |
| `POST` | `/task-distribution/{taskId}/contribute` | JSON: `{ "is_test": boolean, "attempts": [{ "micro_task_id": "<id>", "text_data_set": "<text>" }] }` |
| `POST` | `/task-distribution/{taskId}/contribute_audio` | Multipart form: `is_test` and audio file parts keyed by micro-task ID. The app also sends `batch`, which the current backend handler ignores. |
| `GET` | `/task-distribution/contributor-micro-task-submissions/{microTaskId}` | Submission history for a micro-task |

## Wallet and transactions

| Method | Path | Request details |
|---|---|---|
| `GET` | `/wallet/balance` | No body |
| `POST` | `/wallet/withdraw-money` | JSON: `{ "amount": number, "phoneNumber": "<phone>", "paymentMethod": "<Telebirr or CBE Birr>" }` |
| `GET` | `/transaction` | Query parameters `page`, `limit`, and `type` (`Credit` or `Withdraw`) |

The app requests credit and withdrawal transactions separately, then sorts the returned records by creation date. The withdrawal endpoint returns `503` while the backend's `ENABLE_WITHDRAWALS` setting is not `true`.

## Profile

| Method | Path | Request details |
|---|---|---|
| `GET` | `/iam/users/me` | Fetch the signed-in user's profile |
| `PUT` | `/iam/users/me` | JSON profile update fields |
| `PUT` | `/iam/users/profile` | Multipart upload with the `image` file field |
| `PUT` | `/iam/users/change-password` | `{ "current_password": "<current>", "new_password": "<new>" }` |

## Notifications and reference data

| Method | Path | Request details |
|---|---|---|
| `GET` | `/notifications/me` | Query parameters `page` and `limit` |
| `GET` | `/notifications/count-new` | Returns the unread notification count in the response `data` field |
| `GET` | `/setting/language/all` | Fetch available languages |
| `GET` | `/setting/dialect/all` | Query parameter `language_id` |

**Known mismatch:** the Flutter client currently attempts `PATCH /notifications/{notificationId}/read` and `PATCH /notifications/read-all`, but the backend notification controller currently implements only the two `GET` routes above. The read-state calls therefore have no matching backend handler and fail until those routes are implemented.

## File uploads and error handling

Audio submissions use Dio multipart requests; profile photos use the `image` multipart field. Avoid logging tokens or personal data when diagnosing a failed request. The client maps Dio connection, timeout, and HTTP failures to app exceptions; check the response status and backend logs rather than assuming a fixed rate limit or response shape.

## Source references

- API client and base URL: [`lib/core/api`](lib/core/api)
- Authentication requests: [`auth_remote_data_source.dart`](lib/features/auth/data/datasources/auth_remote_data_source.dart)
- Task, wallet, and submission requests: [`task_remote_data_source.dart`](lib/features/home/data/datasources/task_remote_data_source.dart)
- Profile requests: [`profile_remote_data_source.dart`](lib/features/profile/data/datasources/profile_remote_data_source.dart)
- Notification requests: [`notification_remote_data_source.dart`](lib/features/notification/data/datasources/notification_remote_data_source.dart)
- Setup instructions: [`docs/SETUP.md`](docs/SETUP.md)
