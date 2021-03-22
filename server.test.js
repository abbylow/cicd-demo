const express = require("express");
const supertest = require("supertest");

const app = require("./server");

describe("API test", () => {
    let request = null
    let server = null

    beforeAll(function(done){
        server = app.listen(done)
        request = supertest.agent(server);
    })

    afterAll(function(done){
        server.close(done);
    })

    it("GET /", async () => {
        await request.get("/")
            .expect(200)
            .then((response) => {
                expect(response.text).toBe('Received a GET HTTP method');
            });
    });

    it("POST /", async () => {
        await request.post("/")
            .expect(200)
            .then((response) => {
                expect(response.text).toBe('Received a POST HTTP method');
            });
    });

    it("PUT /", async () => {
        await request.put("/")
            .expect(200)
            .then((response) => {
                expect(response.text).toBe('Received a PUT HTTP method');
            });
    });

    it("DELETE /", async () => {
        await request.delete("/")
            .expect(200)
            .then((response) => {
                expect(response.text).toBe('Received a DELETE HTTP method');
            });
    });

});

