// ─────────────────────────────────────────────
// MongoDB Operations — E-Commerce Product Catalog
// Collection: products
// ─────────────────────────────────────────────

// OP1: insertMany() — insert all 3 documents from sample_documents.json
db.products.insertMany([
  {
    _id: "prod_elec_001",
    category: "Electronics",
    name: "Samsung 4K Smart TV",
    brand: "Samsung",
    price: 55000,
    currency: "INR",
    stock: 30,
    specs: {
      screen_size_inch: 55,
      resolution: "3840x2160",
      voltage: "220V",
      power_consumption_watts: 120,
      connectivity: ["WiFi", "Bluetooth 5.0", "HDMI x3", "USB x2"]
    },
    warranty: {
      years: 2,
      type: "Comprehensive",
      provider: "Samsung India"
    },
    ratings: {
      average: 4.5,
      total_reviews: 2340
    },
    tags: ["television", "4k", "smart-tv", "samsung"],
    created_at: new Date("2024-01-15T10:30:00Z")
  },
  {
    _id: "prod_cloth_001",
    category: "Clothing",
    name: "Men's Slim Fit Formal Shirt",
    brand: "Arrow",
    price: 1299,
    currency: "INR",
    stock: 150,
    attributes: {
      fabric: "100% Cotton",
      fit: "Slim Fit",
      sleeve: "Full Sleeve",
      collar: "Spread Collar",
      care_instructions: ["Machine wash cold", "Do not bleach", "Tumble dry low"]
    },
    variants: [
      { size: "S",  color: "White", sku: "ARW-SHT-S-WHT",  stock: 20 },
      { size: "M",  color: "White", sku: "ARW-SHT-M-WHT",  stock: 45 },
      { size: "L",  color: "Blue",  sku: "ARW-SHT-L-BLU",  stock: 35 },
      { size: "XL", color: "Blue",  sku: "ARW-SHT-XL-BLU", stock: 25 }
    ],
    ratings: {
      average: 4.2,
      total_reviews: 870
    },
    tags: ["shirt", "formal", "mens", "cotton"],
    created_at: new Date("2024-02-10T08:00:00Z")
  },
  {
    _id: "prod_groc_001",
    category: "Groceries",
    name: "Organic Whole Wheat Flour",
    brand: "Aashirvaad",
    price: 320,
    currency: "INR",
    stock: 500,
    packaging: {
      weight_kg: 5,
      type: "Sealed Bag",
      recyclable: true
    },
    dates: {
      manufactured_on: new Date("2024-10-01"),
      expires_on: new Date("2024-12-31"),
      best_before_days: 90
    },
    nutritional_info: {
      serving_size_g: 100,
      calories: 340,
      protein_g: 12,
      carbohydrates_g: 70,
      fat_g: 1.5,
      fibre_g: 11,
      allergens: ["Gluten", "Wheat"]
    },
    certifications: ["FSSAI Certified", "ISO 22000", "Organic India"],
    ratings: {
      average: 4.7,
      total_reviews: 5120
    },
    tags: ["flour", "organic", "wheat", "staples"],
    created_at: new Date("2024-10-05T06:00:00Z")
  }
]);


// OP2: find() — retrieve all Electronics products with price > 20000
db.products.find(
  {
    category: "Electronics",
    price: { $gt: 20000 }
  },
  {
    name: 1,
    brand: 1,
    price: 1,
    category: 1,
    _id: 0
  }
);
// Returns all electronics documents where price exceeds ₹20,000.
// Projection limits output to relevant fields only.


// OP3: find() — retrieve all Groceries expiring before 2025-01-01
db.products.find(
  {
    category: "Groceries",
    "dates.expires_on": { $lt: new Date("2025-01-01") }
  },
  {
    name: 1,
    brand: 1,
    "dates.expires_on": 1,
    _id: 0
  }
);
// Uses dot notation to query inside the nested 'dates' object.
// $lt filters products whose expiry date falls before 1st January 2025.


// OP4: updateOne() — add a "discount_percent" field to a specific product
db.products.updateOne(
  { _id: "prod_elec_001" },
  {
    $set: {
      discount_percent: 10
    }
  }
);
// Targets the Samsung TV document by its _id.
// $set adds the new field without affecting any existing fields.
// If run again, it will simply overwrite the value — safe and idempotent.


// OP5: createIndex() — create an index on the category field
db.products.createIndex(
  { category: 1 },
  { name: "idx_category_asc" }
);
// WHY: The 'category' field is used as the primary filter in OP2 and OP3.
// Without an index, MongoDB performs a full collection scan (COLLSCAN)
// on every query, which becomes slow as the catalog grows to millions of products.
// With this index, MongoDB uses a faster IXSCAN, significantly reducing
// query time for any filter or sort on the category field.
// The value 1 indicates ascending order, which also supports range queries
// and sorted results on category efficiently.