# Каталог доменных событий — «Будущее 2.0»

## Домен: Медицинские услуги

### Bounded Context: Пациентский поток (Patient Flow)

#### AppointmentBooked (Запись создана)

**Источник:** Пациентский поток

**Семантика:** Пациент записан на приём к врачу. Слот в расписании занят.

**Минимальный контракт:**
```json
{
  "eventId": "UUID",
  "eventType": "AppointmentBooked",
  "timestamp": "ISO 8601",
  "payload": {
    "appointmentId": "UUID",
    "patientId": "UUID",
    "doctorId": "UUID",
    "clinicId": "UUID",
    "scheduledAt": "ISO 8601"
  }
}
```

---

#### AppointmentCompleted (Приём завершён)

**Источник:** Пациентский поток

**Семантика:** Визит пациента завершён. Сигнал для выставления счёта и привязки мед.записей к визиту.

**Минимальный контракт:**
```json
{
  "eventId": "UUID",
  "eventType": "AppointmentCompleted",
  "timestamp": "ISO 8601",
  "payload": {
    "appointmentId": "UUID",
    "patientId": "UUID",
    "doctorId": "UUID",
    "clinicId": "UUID",
    "completedAt": "ISO 8601",
    "serviceType": "string"
  }
}
```

---

#### PatientRegistered (Пациент зарегистрирован)

**Источник:** Пациентский поток

**Семантика:** В системе зарегистрирован новый пациент. Сигнал для создания профиля плательщика в Биллинге и предложения банковских продуктов.

**Минимальный контракт:**
```json
{
  "eventId": "UUID",
  "eventType": "PatientRegistered",
  "timestamp": "ISO 8601",
  "payload": {
    "patientId": "UUID",
    "fullName": "string",
    "dateOfBirth": "ISO 8601 (date)",
    "gender": "string",
    "phone": "string",
    "email": "string | null"
  }
}
```

---

### Bounded Context: Клиническая документация (Clinical Records)

#### DiagnosisConfirmed (Диагноз подтверждён)

**Источник:** Клиническая документация

**Семантика:** Врач подтвердил диагноз пациента. Внутреннее событие контекста — не выходит за границы домена.

**Минимальный контракт:**
```json
{
  "eventId": "UUID",
  "eventType": "DiagnosisConfirmed",
  "timestamp": "ISO 8601",
  "payload": {
    "medicalRecordId": "UUID",
    "patientId": "UUID",
    "diagnosisCode": "string (ICD-10)",
    "confirmedBy": "UUID (doctorId)",
    "confirmedAt": "ISO 8601"
  }
}
```

---

#### StudyCompleted (Исследование завершено)

**Источник:** Клиническая документация

**Семантика:** Диагностическое исследование завершено, результаты готовы. Сигнал для ML-платформы на запуск ИИ-анализа. Событие не содержит чувствительных медицинских данных — только идентификатор и тип исследования.

**Минимальный контракт:**
```json
{
  "eventId": "UUID",
  "eventType": "StudyCompleted",
  "timestamp": "ISO 8601",
  "payload": {
    "studyId": "UUID",
    "medicalRecordId": "UUID",
    "studyType": "string",
    "completedAt": "ISO 8601"
  }
}
```

---

## Домен: Финтех / Банкинг

### Bounded Context: Розничный банкинг (Retail Banking)

#### AccountOpened (Счёт открыт)

**Источник:** Розничный банкинг

**Семантика:** Клиенту открыт новый банковский счёт.

**Минимальный контракт:**
```json
{
  "eventId": "UUID",
  "eventType": "AccountOpened",
  "timestamp": "ISO 8601",
  "payload": {
    "accountId": "UUID",
    "accountNumber": "string",
    "customerId": "UUID",
    "accountType": "string",
    "currency": "string (ISO 4217)"
  }
}
```

---

#### PaymentProcessed (Платёж обработан)

**Источник:** Розничный банкинг

**Семантика:** Платёж успешно обработан. Сигнал для Биллинга о подтверждении оплаты счёта.

**Минимальный контракт:**
```json
{
  "eventId": "UUID",
  "eventType": "PaymentProcessed",
  "timestamp": "ISO 8601",
  "payload": {
    "paymentId": "UUID",
    "senderAccountId": "UUID",
    "receiverAccountId": "UUID",
    "amount": "decimal",
    "currency": "string (ISO 4217)",
    "reference": "string | null"
  }
}
```

---

#### TransactionCompleted (Транзакция завершена)

**Источник:** Розничный банкинг

**Семантика:** Операция по счёту завершена — средства зачислены или списаны.

**Минимальный контракт:**
```json
{
  "eventId": "UUID",
  "eventType": "TransactionCompleted",
  "timestamp": "ISO 8601",
  "payload": {
    "transactionId": "UUID",
    "accountId": "UUID",
    "direction": "debit | credit",
    "amount": "decimal",
    "currency": "string (ISO 4217)"
  }
}
```

---

### Bounded Context: Кредитование (Lending)

#### LoanApplicationSubmitted (Заявка на кредит подана)

**Источник:** Кредитование

**Семантика:** Клиент подал заявку на кредит. Заявка передана на рассмотрение.

**Минимальный контракт:**
```json
{
  "eventId": "UUID",
  "eventType": "LoanApplicationSubmitted",
  "timestamp": "ISO 8601",
  "payload": {
    "loanApplicationId": "UUID",
    "customerId": "UUID",
    "requestedAmount": "decimal",
    "currency": "string (ISO 4217)",
    "termMonths": "integer",
    "submittedAt": "ISO 8601"
  }
}
```

---

#### CreditDecisionMade (Кредитное решение принято)

**Источник:** Кредитование

**Семантика:** По заявке принято финальное решение. Сигнал для Розничного банкинга об обновлении статуса клиента.

**Минимальный контракт:**
```json
{
  "eventId": "UUID",
  "eventType": "CreditDecisionMade",
  "timestamp": "ISO 8601",
  "payload": {
    "creditDecisionId": "UUID",
    "loanApplicationId": "UUID",
    "customerId": "UUID",
    "decision": "approved | rejected",
    "approvedAmount": "decimal | null",
    "interestRate": "decimal | null"
  }
}
```

---

#### LoanIssued (Кредит выдан)

**Источник:** Кредитование

**Семантика:** Кредитный договор оформлен, средства подлежат зачислению. Сигнал для Розничного банкинга на зачисление средств на счёт.

**Минимальный контракт:**
```json
{
  "eventId": "UUID",
  "eventType": "LoanIssued",
  "timestamp": "ISO 8601",
  "payload": {
    "loanContractId": "UUID",
    "contractNumber": "string",
    "customerId": "UUID",
    "targetAccountId": "UUID",
    "amount": "decimal",
    "currency": "string (ISO 4217)",
    "termMonths": "integer",
    "interestRate": "decimal"
  }
}
```

---

## Домен: Корпоративные финансы

### Bounded Context: Биллинг и учёт (Billing & Accounting)

#### InvoiceIssued (Счёт выставлен)

**Источник:** Биллинг и учёт

**Семантика:** Счёт выставлен плательщику за оказанные услуги. Сигнал для Розничного банкинга на приём оплаты.

**Минимальный контракт:**
```json
{
  "eventId": "UUID",
  "eventType": "InvoiceIssued",
  "timestamp": "ISO 8601",
  "payload": {
    "invoiceId": "UUID",
    "invoiceNumber": "string",
    "payerId": "UUID",
    "totalAmount": "decimal",
    "currency": "string (ISO 4217)",
    "dueDate": "ISO 8601 (date)",
    "lineItemsCount": "integer"
  }
}
```

---

#### PaymentReceived (Оплата получена)

**Источник:** Биллинг и учёт

**Семантика:** Зафиксирован факт оплаты счёта (полной или частичной). Сигнал для Пациентского потока об обновлении статуса визита.

**Минимальный контракт:**
```json
{
  "eventId": "UUID",
  "eventType": "PaymentReceived",
  "timestamp": "ISO 8601",
  "payload": {
    "paymentRecordId": "UUID",
    "invoiceId": "UUID",
    "payerId": "UUID",
    "amount": "decimal",
    "currency": "string (ISO 4217)",
    "paymentMethod": "string"
  }
}
```

---

#### PeriodClosed (Отчётный период закрыт)

**Источник:** Биллинг и учёт

**Семантика:** Отчётный период закрыт — все проводки зафиксированы, новые проводки за этот период запрещены.

**Минимальный контракт:**
```json
{
  "eventId": "UUID",
  "eventType": "PeriodClosed",
  "timestamp": "ISO 8601",
  "payload": {
    "periodId": "string",
    "periodStart": "ISO 8601 (date)",
    "periodEnd": "ISO 8601 (date)",
    "closedAt": "ISO 8601"
  }
}
```

---

## Домен: Операции (Back Office)

### Bounded Context: Управление персоналом (HR)

#### EmployeeHired (Сотрудник принят)

**Источник:** Управление персоналом (HR)

**Семантика:** В компанию принят новый сотрудник. Сигнал для Пациентского потока на обновление справочника врачей (если применимо).

**Минимальный контракт:**
```json
{
  "eventId": "UUID",
  "eventType": "EmployeeHired",
  "timestamp": "ISO 8601",
  "payload": {
    "employeeId": "UUID",
    "personnelNumber": "string",
    "fullName": "string",
    "position": "string",
    "department": "string",
    "hiredAt": "ISO 8601 (date)"
  }
}
```

---

#### PayrollCalculated (Зарплата рассчитана)

**Источник:** Управление персоналом (HR)

**Семантика:** Зарплатная ведомость за период утверждена. Сигнал для Биллинга на формирование бухгалтерских проводок.

**Минимальный контракт:**
```json
{
  "eventId": "UUID",
  "eventType": "PayrollCalculated",
  "timestamp": "ISO 8601",
  "payload": {
    "payrollId": "UUID",
    "period": "string",
    "department": "string",
    "totalGross": "decimal",
    "totalDeductions": "decimal",
    "totalNet": "decimal",
    "currency": "string (ISO 4217)",
    "employeeCount": "integer"
  }
}
```

---

### Bounded Context: Инвентаризация (Inventory)

#### StockReplenished (Запасы пополнены)

**Источник:** Инвентаризация

**Семантика:** Поставка получена, запасы на складе пополнены.

**Минимальный контракт:**
```json
{
  "eventId": "UUID",
  "eventType": "StockReplenished",
  "timestamp": "ISO 8601",
  "payload": {
    "purchaseOrderId": "UUID",
    "warehouseId": "UUID",
    "itemsReceived": [
      {
        "inventoryItemId": "UUID",
        "sku": "string",
        "quantity": "integer"
      }
    ]
  }
}
```

---

#### ItemConsumed (Материал израсходован)

**Источник:** Инвентаризация

**Семантика:** Расходный материал списан со склада. Сигнал для Биллинга на списание в учёте.

**Минимальный контракт:**
```json
{
  "eventId": "UUID",
  "eventType": "ItemConsumed",
  "timestamp": "ISO 8601",
  "payload": {
    "movementId": "UUID",
    "inventoryItemId": "UUID",
    "sku": "string",
    "quantity": "integer",
    "warehouseId": "UUID",
    "reason": "string"
  }
}
```

---

#### LowStockAlert (Низкий остаток)

**Источник:** Инвентаризация

**Семантика:** Количество единиц на складе опустилось ниже минимального порога. Сигнал для Биллинга на формирование заказа на закупку.

**Минимальный контракт:**
```json
{
  "eventId": "UUID",
  "eventType": "LowStockAlert",
  "timestamp": "ISO 8601",
  "payload": {
    "inventoryItemId": "UUID",
    "sku": "string",
    "currentQuantity": "integer",
    "minimumThreshold": "integer",
    "warehouseId": "UUID"
  }
}
```

---

## Домен: ИИ-сервисы

### Bounded Context: ML-платформа (ML Platform)

#### InferenceCompleted (Inference завершён)

**Источник:** ML-платформа

**Семантика:** ИИ-анализ исследования завершён, результат готов. Сигнал для Клинической документации на запись результата в медицинскую карту. Событие содержит ссылку на результат, но не содержит самих медицинских данных.

**Минимальный контракт:**
```json
{
  "eventId": "UUID",
  "eventType": "InferenceCompleted",
  "timestamp": "ISO 8601",
  "payload": {
    "inferenceRequestId": "UUID",
    "studyId": "UUID",
    "modelId": "UUID",
    "modelVersion": "string",
    "resultStatus": "success | error",
    "resultUri": "string",
    "completedAt": "ISO 8601"
  }
}
```

---

#### ModelDeployed (Модель задеплоена)

**Источник:** ML-платформа

**Семантика:** Новая версия модели развёрнута в production. Внутреннее событие платформы.

**Минимальный контракт:**
```json
{
  "eventId": "UUID",
  "eventType": "ModelDeployed",
  "timestamp": "ISO 8601",
  "payload": {
    "modelId": "UUID",
    "modelVersion": "string",
    "taskType": "string",
    "deployedAt": "ISO 8601"
  }
}
```
