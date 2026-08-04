import '../domain/models/customer.dart';

/// Catálogo mock de clientes / terceros para el flujo POS.
abstract final class MockCustomers {
  static final List<Customer> _items = [
    const Customer(
      id: 'c01',
      name: 'Comercial Andina S.A.S.',
      documentType: 'NIT',
      documentNumber: '900123456-1',
      email: 'compras@andina.com',
      phone: '3001234567',
      address: 'Cra 15 # 88-45',
      city: 'Bogotá',
      taxId: '900123456-1',
    ),
    const Customer(
      id: 'c02',
      name: 'María Fernanda López',
      documentType: 'CC',
      documentNumber: '1023456789',
      email: 'mf.lopez@email.com',
      phone: '3109876543',
      address: 'Calle 45 # 12-30',
      city: 'Medellín',
    ),
    const Customer(
      id: 'c03',
      name: 'Distribuciones del Norte',
      documentType: 'NIT',
      documentNumber: '800987654-3',
      email: 'ventas@delnorte.co',
      phone: '3155551212',
      address: 'Av. Circunvalar 22',
      city: 'Barranquilla',
      taxId: '800987654-3',
    ),
    const Customer(
      id: 'c04',
      name: 'Carlos Andrés Ruiz',
      documentType: 'CC',
      documentNumber: '79856412',
      email: 'carlos.ruiz@gmail.com',
      phone: '3201112233',
      address: 'Transversal 6 # 45-10',
      city: 'Cali',
    ),
    const Customer(
      id: 'c05',
      name: 'Minimercado El Sol',
      documentType: 'NIT',
      documentNumber: '901234567-8',
      email: 'elsol@negocio.co',
      phone: '3014445566',
      address: 'Calle 10 # 5-20',
      city: 'Pereira',
      taxId: '901234567-8',
    ),
  ];

  static List<Customer> get all => List.unmodifiable(_items);

  static List<Customer> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return _items.where((c) {
      return c.name.toLowerCase().contains(q) ||
          c.documentNumber.toLowerCase().contains(q) ||
          c.email.toLowerCase().contains(q) ||
          c.phone.contains(q);
    }).toList();
  }

  static Customer add(Customer customer) {
    final created = customer.copyWith(
      id: 'c${(_items.length + 1).toString().padLeft(2, '0')}',
    );
    _items.add(created);
    return created;
  }
}
