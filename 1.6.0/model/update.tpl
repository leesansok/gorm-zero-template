
func (m *default{{.upperStartCamelObject}}Model) Update(ctx context.Context, tx *gorm.DB, data *{{.upperStartCamelObject}}) error {
    {{if .withCache}}old, err := m.FindOne(ctx, data.{{.upperStartCamelPrimaryKey}})
    if err != nil && err != ErrNotFound {
        return err
    }
    err = m.ExecCtx(ctx, func(conn *gorm.DB) error {
        db := conn
        if tx != nil {
            db = tx
        }
        return db.Save(data).Error
    }, m.getCacheKeys(old)...){{else}}db := m.conn
        if tx != nil {
            db = tx
        }
        err:= db.WithContext(ctx).Save(data).Error{{end}}
    return err
}
{{if .withCache}}
func (m *default{{.upperStartCamelObject}}Model) getCacheKeys(data *{{.upperStartCamelObject}}) []string {
    if data == nil {
        return []string{}
    }
    {{.keys}}
    cacheKeys := []string{
        {{.keyValues}},
    }
    cacheKeys = append(cacheKeys, m.customCacheKeys(data)...)
    return cacheKeys
}
{{end}}

func (m *default{{.upperStartCamelObject}}Model) FindCount(ctx context.Context, query string, args ...interface{}) (int64,error) {
    var count int64
    err := m.QueryNoCacheCtx(ctx, &count, func(conn *gorm.DB, v interface{}) error {
        if strutil.IsBlank(query) {
            return conn.Model(&{{.upperStartCamelObject}}{}).Count(&count).Error
        }
    	return conn.Model(&{{.upperStartCamelObject}}{}).Where(query, args...).Count(&count).Error
    })
	switch err {
	case nil:
		return count, nil
	default:
		return 0, err
	}
}

func (m *default{{.upperStartCamelObject}}Model) FindAll(ctx context.Context, orderBy string, query string, args ...interface{}) ([]*{{.upperStartCamelObject}},error) {
    var resp []*{{.upperStartCamelObject}}
    err := m.QueryNoCacheCtx(ctx, &resp, func(conn *gorm.DB, v interface{}) error {
        if strutil.IsBlank(query) {
            return conn.Model(&{{.upperStartCamelObject}}{}).Find(&resp).Error
        }
    	return conn.Model(&{{.upperStartCamelObject}}{}).Where(query).Find(&resp).Error
    })
	switch err {
	case nil:
		return resp, nil
	default:
		return nil, err
	}
}

func (m *default{{.upperStartCamelObject}}Model) FindPageListByPageWithTotal(ctx context.Context, page, pageSize int, orderBy string, query string, args ...interface{}) ([]*{{.upperStartCamelObject}},int64,error) {
    total, err := m.FindCount(ctx, query, args...)
    if err != nil {
        return nil, 0, err
    }
    offset := (page - 1) * pageSize
    var resp []*{{.upperStartCamelObject}}
    err = m.QueryNoCacheCtx(ctx, &resp, func(conn *gorm.DB, v interface{}) error {
        if strutil.IsBlank(query) {
    	    return conn.Model(&{{.upperStartCamelObject}}{}).Limit(pageSize).Offset(offset).Find(&resp).Error
    	}
    	return conn.Model(&{{.upperStartCamelObject}}{}).Where(query, args...).Limit(pageSize).Offset(offset).Find(&resp).Error
    })
	switch err {
	case nil:
		return resp, total, nil
	default:
		return nil, 0, err
	}
}
