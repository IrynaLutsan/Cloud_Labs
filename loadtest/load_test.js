import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE_URL = __ENV.BASE_URL || 'http://cloud-labs-alb-99272465.us-east-1.elb.amazonaws.com';

export const options = {
  stages: [
    { duration: '2m30s', target: 50 }, //наростання до 50 користувачів
    { duration: '5m',    target: 50 }, //стале навантаження 50 користувачів
    { duration: '2m',    target: 0  }, //спад до 0
  ],
};

export default function () {
  const uniqueId = `${__VU}_${__ITER}_${Date.now()}`;
  const headers = { 'Content-Type': 'application/json' };

  //(POST /users)
  const payload = JSON.stringify({
    username: `user_${uniqueId}`,
    email: `user_${uniqueId}@example.com`,
    password_hash: 'hashed_secret_123',
    full_name: `Test User ${uniqueId}`,
    phone: '+380501234567'
  });

  const postRes = http.post(`${BASE_URL}/users`, payload, { headers });
  check(postRes, { 'POST /users status is 201': (r) => r.status === 201 });

  let createdUserId = 1;
  try {
    const body = JSON.parse(postRes.body);
    if (body && body.id) createdUserId = body.id;
  } catch (e) {}

  //(9 запитів GET)
  for (let i = 0; i < 5; i++) {
    const res = http.get(`${BASE_URL}/users`);
    check(res, { 'GET /users status is 200': (r) => r.status === 200 });
  }

  for (let i = 0; i < 4; i++) {
    const res = http.get(`${BASE_URL}/users/${createdUserId}`);
    check(res, { 'GET /users/:id status is 200': (r) => r.status === 200 });
  }

  sleep(0.2);
}