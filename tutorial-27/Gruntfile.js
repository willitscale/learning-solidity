module.exports = function(grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    watch: {
      scripts: {
        files: ['scripts/*.js'],
        tasks: ['jshint'],
        options: {
          spawn: false,
        },
      }
    },
    connect: {
      server: {
        options: {
          port: 8000,
          hostname: '*',
          base: './'
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-connect');

  grunt.registerTask('default', ['connect','watch']);
};
