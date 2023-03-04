class SaveUser < User::SaveOperation
  upsert_lookup_columns :email
end
