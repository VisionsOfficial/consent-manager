import { Schema, model } from "mongoose";
import { IPrivacyNoticeDocument } from "../../types/models";

const schema = new Schema<IPrivacyNoticeDocument>(
  {
    contract: String,
    title: String,
    lastUpdated: String,
    dataProvider: String,
    serviceChains: [Schema.Types.Mixed],
    controllerDetails: {
      name: String,
      contact: String,
      representative: String,
      dpo: {
        name: String,
        contact: String,
      },
    },
    purposes: [Schema.Types.Mixed],
    categoriesOfData: [String],
    data: [Schema.Types.Mixed],
    recipients: [String],
    internationalTransfers: {
      countries: [String],
      safeguards: String,
    },
    retentionPeriod: String,
    piiPrincipalRights: [String],
    withdrawalOfConsent: String,
    complaintRights: String,
    provisionRequirements: String,
    automatedDecisionMaking: {
      details: String,
    },
    jsonld: { type: String },
    schema_version: { type: String, default: "0.1.0" },
    archivedAt: { type: String },
  },
  { timestamps: true }
);

const PrivacyNotice = model<IPrivacyNoticeDocument>("PrivacyNotice", schema);

export default PrivacyNotice;
