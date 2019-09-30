FROM archlinux/base as build
WORKDIR /build
RUN pacman -Sy
RUN pacman --noconfirm -S base-devel


#RUN pacman --noconfirm -Sy git
#RUN git clone --depth 1 https://github.com/ton-blockchain/ton.git .

RUN pacman --noconfirm -S cmake

RUN mkdir source
RUN curl https://test.ton.org/ton-test-liteclient-full.tar.xz > source/client.tar.xz
RUN cd source/ && tar -xvf client.tar.xz

WORKDIR /build/result
RUN cmake /build/source/lite-client
RUN cmake --build . --target lite-client
RUN cmake --build . --target fift
RUN cmake --build . --target func

RUN curl https://test.ton.org/ton-lite-client-test1.config.json > ton-lite-client-test1.config.json

FROM archlinux/base

COPY --from=build /build/result ~