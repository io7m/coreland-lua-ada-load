#include "ctxt.h"
#include "install.h"

struct install_item insthier[] = {
  {INST_MKDIR, 0, 0, ctxt_bindir, 0, 0, 0755},
  {INST_MKDIR, 0, 0, ctxt_incdir, 0, 0, 0755},
  {INST_MKDIR, 0, 0, ctxt_dlibdir, 0, 0, 0755},
  {INST_MKDIR, 0, 0, ctxt_slibdir, 0, 0, 0755},
  {INST_MKDIR, 0, 0, ctxt_repos, 0, 0, 0755},
  {INST_COPY, "lua-ada-load-conf.c", 0, ctxt_repos, 0, 0, 0644},
  {INST_COPY, "lua-load.ads", 0, ctxt_repos, 0, 0, 0644},
  {INST_COPY, "lua-load.ads", 0, ctxt_incdir, 0, 0, 0644},
  {INST_COPY, "lua-load.adb", 0, ctxt_repos, 0, 0, 0644},
  {INST_COPY, "lua-load.adb", 0, ctxt_incdir, 0, 0, 0644},
  {INST_COPY, "lua-load.ali", 0, ctxt_repos, 0, 0, 0644},
  {INST_COPY, "lua-load.ali", 0, ctxt_incdir, 0, 0, 0444},
  {INST_COPY, "lua-load.sld", 0, ctxt_repos, 0, 0, 0644},
  {INST_COPY, "lua-load.a", "liblua-load.a", ctxt_slibdir, 0, 0, 0644},
  {INST_COPY, "lua-ada-load-conf.ld", 0, ctxt_repos, 0, 0, 0644},
  {INST_COPY, "lua-ada-load-conf", 0, ctxt_bindir, 0, 0, 0755},
};
unsigned long insthier_len = sizeof(insthier) / sizeof(struct install_item);
