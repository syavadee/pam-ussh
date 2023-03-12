MODULE := pam_ussh
NEED_SYMLINK := $(shell if ! stat .go/src/pam-ussh 2>&1 > /dev/null ; then echo "yes" ; fi)

module: test
	GO111MODULE=auto GOPATH=${PWD}/.go go build -buildmode=c-shared -o ${MODULE}.so

test: *.go .go/src
	GO111MODULE=auto GOPATH=${PWD}/.go go test -cover

.go/src:
	-mkdir -p ${PWD}/.go/src
	-GOPATH=${PWD}/.go go install golang.org/x/crypto/ssh@latest
	-GOPATH=${PWD}/.go go install golang.org/x/crypto/ssh/agent@latest
	-GOPATH=${PWD}/.go go install github.com/stretchr/testify/require@latest
	ln -frs ${PWD}/.go/pkg/mod/github.com  ${PWD}/.go/src/github.com
	ln -frs ${PWD}/.go/pkg/mod/golang.org  ${PWD}/.go/src/golang.org
	ln -frs ${PWD}/.go/pkg/mod/gopkg.in  ${PWD}/.go/src/gopkg.in
	ln -frs ${PWD}/.go/pkg/mod/golang.org/x/crypto@v0.7.0 ${PWD}/.go/pkg/mod/golang.org/x/crypto
	ln -frs ${PWD}/.go/pkg/mod/github.com/stretchr/testify@v1.8.2 ${PWD}/.go/pkg/mod/github.com/stretchr/testify
	ln -frs ${PWD}/.go/pkg/mod/github.com/davecgh/go-spew@v1.1.1 ${PWD}/.go/pkg/mod/github.com/davecgh/go-spew
	ln -frs ${PWD}/.go/pkg/mod/github.com/pmezard/go-difflib@v1.0.0 ${PWD}/.go/pkg/mod/github.com/pmezard/go-difflib
	ln -frs ${PWD}/.go/pkg/mod/gopkg.in/yaml.v3@v3.0.1 ${PWD}/.go/pkg/mod/gopkg.in/yaml.v3
	# .go/src/github.com/davecgh/go-spew/spew
clean:
	go clean
	-rm -f ${MODULE}.so ${MODULE}.h
	-rm -rf .go/

.PHONY: test module download_deps clean
