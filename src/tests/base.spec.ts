import mongoose from "mongoose";

before(async function () {
  await mongoose.connect(process.env.MONGO_URI_TEST);
  await mongoose.connection.db.dropDatabase();
});

after(async function () {
  await mongoose.connection.close();
});
