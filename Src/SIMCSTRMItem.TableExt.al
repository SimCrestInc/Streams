tableextension 50100 "SIMC STRM Item" extends Item
{
    fields
    {
        field(50100; "SIMC STRM Item Attachment"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Item Attachment';
        }
    }
}