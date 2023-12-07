Update(ctx context.Context, tx *gorm.DB, data *{{.upperStartCamelObject}}) error
Update(ctx context.Context, tx *gorm.DB, columns map[string]interface{}, id int64) error
FindAll(ctx context.Context, orderBy string, query string, args ...interface{}) ([]*{{.upperStartCamelObject}},error)
FindCount(ctx context.Context, query string, args ...interface{}) (int64,error)
FindPageListByPageWithTotal(ctx context.Context, page, pageSize int, orderBy string, query string, args ...interface{}) ([]*{{.upperStartCamelObject}}, int64, error)
