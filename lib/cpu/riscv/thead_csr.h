/* T-HEAD M mode CSR.  */
#define CSR_MXSTATUS 0x7c0
#define CSR_MHCR 0x7c1
#define CSR_MCOR 0x7c2
/* T-HEAD S mode CSR.  */
#define CSR_SXSTATUS 0x5c0
#define CSR_SHCR 0x5c1
#ifdef DECLARE_CSR_THEAD
/* T-HEAD extentions.  */
DECLARE_CSR_THEAD(mxstatus, CSR_MXSTATUS)
DECLARE_CSR_THEAD(mhcr, CSR_MHCR)
DECLARE_CSR_THEAD(mcor, CSR_MCOR)
/* T-HEAD extentions.  */
DECLARE_CSR_THEAD(sxstatus, CSR_SXSTATUS)
DECLARE_CSR_THEAD(shcr, CSR_SHCR)
#endif
