package file_upload

type UploadedFileModel struct {
	FileName    string `json:"file_name"`
	Url         string `json:"url"`
	ContentType string `json:"content_type"`
	Size        int64  `json:"size"`
	StoragePath string `json:"storage_path"`
}
